require 'sinatra/base'

# Models
require './models/notebook'
require './models/note'

class GfmNotes < Sinatra::Base
  configure do
    enable :logging
    use Rack::CommonLogger
  end

  before do
    md_notes_path = "#{Dir.getwd}/md-notes/"
    Dir.mkdir md_notes_path unless Dir.exists? md_notes_path
  end

  get '/' do
    @notebooks = Notebook.get_all
    haml :index 
  end

  post '/notebooks' do # JSON route for AJAX calls
    @notebook = Notebook.new(params[:file_name]) # JSON route for AJAX calls
    if @notebook.save
      return [200, {name: @notebook.name}.to_json]
    else
      return [500, {name: @notebook.name, message: @notebook.error}.to_json]
    end
  end

  get '/notebooks/:notebook_name' do 
    @notebook = Notebook.new(params[:notebook_name])
    @notes = @notebook.notes
    haml :show
  end

  get '/notebooks/:notebook_name/:note_name' do
    @note = Note.new(params[:notebook_name], params[:note_name])
    @html = @note.generate_preview
    haml :show_note
  end
end
