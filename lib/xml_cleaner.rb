class XMLCleaner
  VALID_XML_CHARS = /^(
    [\x09\x0A\x0D\x20-\x7E] # ASCII
    | [\xC2-\xDF][\x80-\xBF] # non-overlong 2-byte
    | \xE0[\xA0-\xBF][\x80-\xBF] # excluding overlongs
    | [\xE1-\xEC\xEE][\x80-\xBF]{2} # straight 3-byte
    | \xEF[\x80-\xBE]{2} #
    | \xEF\xBF[\x80-\xBD] # excluding U+fffe and U+ffff
    | \xED[\x80-\x9F][\x80-\xBF] # excluding surrogates
    | \xF0[\x90-\xBF][\x80-\xBF]{2} # planes 1-3
    | [\xF1-\xF3][\x80-\xBF]{3} # planes 4-15
    | \xF4[\x80-\x8F][\x80-\xBF]{2} # plane 16
  )*$/nx;

  def self.clean(xml)
    XMLCleaner.new(xml).clean!
  end

  def initialize(xml)
    @xml = xml
  end

  def remove_invalid_chars!
    @xml = @xml.encode('ASCII-8BIT', invalid: :replace, undef: :replace, replace: '').split('').select {|x| x =~ VALID_XML_CHARS }.join.encode('UTF-8')
  end

  def xmllint!
    IO.popen("xmllint - --format --encode utf-8", "r+") do |f|
      f.write @xml
      f.close_write
      @xml = f.read
    end
  end

  def clean!
    remove_invalid_chars!
    xmllint!
    @xml
  end
end
