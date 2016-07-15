# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  type                    :string           not null
#  user_id                 :integer          not null
#  strategy                :integer          not null
#  input_file_file_name    :string
#  input_file_content_type :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  status                  :integer          default(0), not null
#  progress                :integer
#  total                   :integer
#  error_message           :text
#  error_trace             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ListImport
  class MyAnimeList < ListImport
    include Enumerable

    # We can only accept files as input right now, not usernames
    validates :input_text, absence: true
    # Accept .gz or .xml.gz
    validates_attachment :input_file, content_type: {
      content_type: %w[application/gzip application/xml]
    }, presence: true

    def count
      xml.css('user_total_anime, user_total_manga').map(&:content).map(&:to_i).
        sum
    end

    def each
      xml.css('anime, manga').each do |media|
        row = Row.new(media)
        yield row.media, row.data
      end
    end

    private

    def gzipped?
      input_file.content_type.include? 'gzip'
    end

    def xml
      return @xml if @xml

      data = open(input_file.path)
      data = Zlib::GzipReader.new(data) if gzipped?         # Unzip
      data = data.read
      # We can't fix Xinil, but we can fix his mess.
      data.scrub!                                           # Scrub encoding
      data.gsub!(/&(?!(?:amp|lt|gt|quot|apos);)/, '&amp;')  # Fix escaping

      @xml = Nokogiri::XML(data)
      @xml
    end
  end
end
