class AnimeIndex < Chewy::Index
  define_type Anime.includes(:genres, castings: [:character, :person]) do
    # Crutches are optimized queries for efficiently grabbing HABTM data
    crutch :people do |collection|
      ids = collection.map(&:id)
      data = Casting.joins(:person).where(media_id: ids, media_type: 'Anime')
        .uniq.pluck(:media_id, 'people.name')
      # Convert from [id, name] to id => [names]
      data.each.with_object({}) { |(id, name), result| (result[id] ||= []).push(name) }
    end
    crutch :characters do |collection|
      ids = collection.map(&:id)
      data = Casting.joins(:character).where(media_id: ids, media_type: 'Anime')
        .uniq.pluck(:media_id, 'characters.name')
      # Convert from [id, name] to id => [names]
      data.each.with_object({}) { |(id, name), result| (result[id] ||= []).push(name) }
    end

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
      field :people, value: -> (a, crutch) { crutch.people[a.id].uniq }
      field :characters, value: -> (a, crutch) { crutch.characters[a.id].uniq }
    end
  end
end
