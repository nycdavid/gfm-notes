require 'sinatra'
require 'github-markdown-preview'

get '/' do
  @notebooks = get_notebooks
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

def get_notebooks
  notebooks = []
  Dir.glob('md-notes/**/*.md').each do |f|
    name = f.split('/')[2]
    notebooks << name unless notebooks.include? name
  end
  notebooks
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
