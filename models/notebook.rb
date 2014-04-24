class Notebook
  def initialize
  end

  def self.get_all
    notebooks = []
    Dir.glob('md-notes/**/*.md').each do |f|
      name = f.split('/')[2]
      notebooks << name unless notebooks.include? name
    end
    notebooks
  end

  def self.notes
  end

  private
end
