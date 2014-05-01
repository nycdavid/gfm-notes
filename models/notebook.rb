class Notebook
  attr_accessor :name, :path, :notes, :error

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

  def save
    begin
      Dir.mkdir @path
    rescue Errno::EEXIST
      self.error = 'already exists'
    end
    if Dir.exists?(@path) && self.error.nil? 
      true
    else
      false
    end
  end

  def self.get_all
    notebooks = []
    Dir.glob('md-notes/notebooks/**').each do |f|
      name = f.split('/').last
      notebooks << name unless notebooks.include? name
    end
    notebooks
  end
end
