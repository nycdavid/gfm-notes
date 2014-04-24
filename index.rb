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
  @notebook = params[:notebook_name]
  @note = params[:note_name]
  @html = generate_preview(@notebook, @note)
  haml :show_note
end

def get_notes(notebook)
  notes = []
  Dir.glob("md-notes/notebooks/#{notebook}/*.md").each do |n|
    notes << n.split('/')[3].gsub(/.md/, '')
  end
  notes
end

def generate_preview(notebook, note)
  note_path = "md-notes/notebooks/#{notebook}/#{note}.md"
  preview = GithubMarkdownPreview::HtmlPreview.new(note_path)
  File.read(preview.preview_file)
end
