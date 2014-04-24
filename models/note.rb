class Note
  def initialize
  end

  def generate_preview(notebook, note)
    note_path = "md-notes/notebooks/#{notebook}/#{note}.md"
    preview = GithubMarkdownPreview::HtmlPreview.new(note_path)
    File.read(preview.preview_file)
  end
end
