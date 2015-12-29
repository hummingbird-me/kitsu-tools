module IndexTranslatable
  extend ActiveSupport::Concern

  TRANSLATION_MAPPINGS = {
    '*_jp' => 'cjk',
    'zh_*' => 'cjk',
    'ko_*' => 'cjk',
    'en_*' => 'english'
  }

  class_methods do
    def translatable_field(name)
      # TODO: fix romaji in the db
      field name, type: 'object'
      TRANSLATION_MAPPINGS.each do |mask, analyzer|
        template "#{name}.#{mask}", type: 'string', analyzer: analyzer
      end
    end
  end
end
