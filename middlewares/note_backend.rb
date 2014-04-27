require 'faye/websocket'
require 'listen'
require_relative '../models/note'

module Notes
  class NoteBackend
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})
        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          p [:message, event.data]
          @client.each {|client| client.send(event.data)}
        end

        # Listen for file changes
        listener = Listen.to("#{Dir.getwd}/md-notes/", only: /\.md$/) do |m, a, r|
          m.each do |file|
            notebook, note = file.split('/').last(2)
            note = Note.new(notebook, note)
            note = {name: note.name, markup: note.generate_preview}
            ws.send(note.to_json)
          end
        end
        listener.start

        # Return async Rack Response
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
