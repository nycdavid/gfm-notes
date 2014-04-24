require 'github-markdown-preview'

class Note
  attr_accessor :notebook_name, :name, :path, :preview

  def initialize(notebook, note)
    @notebook_name = notebook
    @name = note
    @path = "#{Dir.getwd}/md-notes/notebooks/#{@notebook_name}/#{@name}.md"
    @preview = generate_preview
  end

  def generate_preview
    preview = GithubMarkdownPreview::HtmlPreview.new(@path)
    File.read(preview.preview_file)
  end
end
