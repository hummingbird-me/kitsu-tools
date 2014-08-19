require 'test_helper'
require_dependency 'xml_cleaner'

class XMLCleanerTest < ActiveSupport::TestCase
  test "cleans xml with illegal characters" do
    xml = File.read('test/fixtures/xml_cleaner/invalid_chars.xml')
    assert(XMLCleaner.clean(xml).length > 0)
  end
end
