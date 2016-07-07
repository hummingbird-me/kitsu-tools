require 'simplecov'

module SimpleCov
  module Formatter
    class MergedFormatter
      def format(result)
        SimpleCov::Formatter::HTMLFormatter.new.format(result)
        CodeClimate::TestReporter::Formatter.new.format(result)
      end
    end
  end
end

if ENV['CODECLIMATE_REPO_TOKEN']
  CodeClimate::TestReporter.start
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
else
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/db/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Mailers', 'app/mailers'
    add_group 'Services', 'app/services'
    add_group 'Workers', 'app/workers'
    add_group 'Serializers', 'app/serializers'
    add_group 'Policies', 'app/policies'
    add_group 'Libs', 'lib/'

    track_files '{app,lib}/**/*.rb'
  end
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end
