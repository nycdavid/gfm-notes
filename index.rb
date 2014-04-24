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
  @notebook = params[:notebook_name]
  @notes = get_notes(@notebook)
  haml :show
end

get '/notebooks/:notebook_name/:note_name' do
  @note = Note.new(params[:notebook_name], params[:note_name])
  @notebook_name = @note.notebook_name
  @note_name = @note.name
  @html = @note.preview
  haml :show_note
end

def get_notes(notebook)
  notes = []
  Dir.glob("md-notes/notebooks/#{notebook}/*.md").each do |n|
    notes << n.split('/')[3].gsub(/.md/, '')
  end
  notes
end
