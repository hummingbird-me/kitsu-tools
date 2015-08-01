def read_fixture(name, erb = true)
  filename = File.realpath(File.join('./fixtures/', name), __dir__)
  content = open(filename).read
  erb ? ERB.new(content).result : content
end
