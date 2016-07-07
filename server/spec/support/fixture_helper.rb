class Fixture
  attr_accessor :name, :filename, :content
  @@cache = Hash.new { |h, k| h[k] = {} }

  def initialize(name, opts = {})
    @name = name
    @opts = opts
  end

  def to_s
    @opts[:erb] ? compiled : content
  end

  def to_file
    open(filename)
  end

  private

  def compiled
    @@cache[:compiled][name] ||= ERB.new(content).tap do |erb|
      erb.filename = filename
    end
    @@cache[:compiled][name]
  end

  def content
    @@cache[:content][name] ||= open(filename).read
    @@cache[:content][name]
  end

  def filename
    File.realpath(File.join('spec/fixtures/', name), Rails.root)
  end
end

# Global helper method for easy, cached access to fixtures
def fixture(name, opts = {})
  Fixture.new(name, opts).to_s
end
