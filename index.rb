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
