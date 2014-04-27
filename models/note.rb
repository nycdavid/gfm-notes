require './initializers/syntax'

class Note
  attr_accessor :notebook_name, :name, :path

  def initialize(notebook, note, path=nil)
    @notebook_name = notebook
    @name = note.gsub(/.md/, '')
    @path = path.nil? ? "#{Dir.getwd}/md-notes/notebooks/#{@notebook_name}/#{@name}.md" : path
  end

  def generate_preview
    markdown = Redcarpet::Markdown.new(HTML, fenced_code_blocks: true, tables: true, strikethrough: true)
    markdown.render(File.read(@path))
  end
end
