class AnimeIndex < Chewy::Index
  define_type Anime.includes(:genres, castings: [:character, :person]) do
    root date_detection: false do
      # Oops, we did ja_en this backwards
      # TODO: fix this
      template 'titles.*_jp', type: 'string', analyzer: 'cjk'
      template 'titles.zh_*', type: 'string', analyzer: 'cjk'
      template 'titles.ko_*', type: 'string', analyzer: 'cjk'

      # Titles and freeform text
      field :titles, type: 'object'
      field :abbreviated_titles, type: 'string'
      field :synopsis, type: 'string', analyzer: 'english'
      # Enumerated values
      field :age_rating, :show_type, type: 'string'
      # Various Data
      field :episode_count, type: 'short' # Max of 32k or so is reasonable
      field :average_rating, type: 'float'
      field :start_date, :end_date, :created_at, type: 'date'
      field :genres, value: -> (a) { a.genres.map(&:name) }
      field :user_count, type: 'short'
      # Castings
      field :people, value: -> (a) {
        a.castings.map { |c|
          c.person.name unless c.person.nil?
        }.compact.uniq
      }
      field :characters, value: -> (a) {
        a.castings.map { |c|
          c.character.name unless c.character.nil?
        }.compact.uniq
      }
    end
  end
end
