require 'sinatra'
require 'github-markdown-preview'

# Models
require './models/notebook'
require './models/note'

get '/' do
  @notebooks = Notebook.get_all
  haml :index 
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
