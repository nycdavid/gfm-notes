class Notebook
  attr_accessor :name, :path, :notes

  def initialize(notebook)
    @name = notebook
    @path = "#{Dir.getwd}/md-notes/notebooks/#{@name}/"
    @notes = fetch_notes
  end

  def fetch_notes
    notes = []
    Dir.glob("#{Dir.getwd}/md-notes/notebooks/#{@name}/*.md").each do |note|
      notes << Note.new(@name, note.split('/').last.gsub(/.md/, ''))
    end
    notes
  end

  def self.get_all
    notebooks = []
    Dir.glob('md-notes/**/*.md').each do |f|
      name = f.split('/')[2]
      notebooks << name unless notebooks.include? name
    end
    notebooks
  end

  private
end
