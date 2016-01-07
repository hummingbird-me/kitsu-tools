class AttachmentFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    raise 'Invalid attachment field' unless value.is_a? Paperclip::Attachment

    urls = value.styles.keys.map { |style| [style, value.url(style)] }
    urls << [:original, value.url]
    Hash[urls]
  end
end
