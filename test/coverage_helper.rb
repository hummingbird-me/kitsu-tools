class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    CodeClimate::TestReporter::Formatter.new.format(result)
  end
end

if ENV['CODECLIMATE_REPO_TOKEN']
  CodeClimate::TestReporter.start
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
else
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/config/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Services', 'app/services'
    add_group 'Serializers', 'app/serializers'
    add_group 'Libs', 'lib/'
  end
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end
