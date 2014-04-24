require 'github-markdown-preview'

class Note
  attr_accessor :notebook_name, :name, :path

  def initialize(notebook, note, path=nil)
    @notebook_name = notebook
    @name = note
    @path = path.nil? ? "#{Dir.getwd}/md-notes/notebooks/#{@notebook_name}/#{@name}.md" : path
  end

  def generate_preview
    preview = GithubMarkdownPreview::HtmlPreview.new(@path)
    File.read(preview.preview_file)
  end
end
