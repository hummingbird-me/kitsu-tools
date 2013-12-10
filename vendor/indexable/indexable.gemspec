Gem::Specification.new do |s|
  s.name = 'indexable'
  s.version = '0.0.1'
  s.date = '2013-12-10'
  s.summary = 'Rack middleware that executes javascript before serving pages to crawlers.'
  s.authors = ["Vikhyat Korrapati"]
  s.email = 'c@vikhyat.net'
  s.files = ['lib/indexable.rb', 'lib/render_page.js']
  s.homepage = 'https://github.com/vikhyat/indexable'
  s.license = 'MIT'

  s.add_runtime_dependency "phantomjs.rb", ["~> 2.0"]
end
