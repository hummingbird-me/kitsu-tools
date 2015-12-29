class MediaIndex < Chewy::Index
  class << self
    # Convert from [[id, name], ...] to id => [names...]
    def groupify(plucks)
      plucks.each.with_object({}) {|(id, name), out| (out[id] ||= []).push(name) }
    end

    # Get character names for a series
    def get_characters(type, ids)
      groupify Casting.joins(:character).where(media_id: ids, media_type: type)
        .uniq.pluck(:media_id, 'characters.name')
    end

    # Get person names for a series
    def get_people(type, ids)
      groupify Casting.joins(:person).where(media_id: ids, media_type: type).uniq
        .pluck(:media_id, 'people.name')
    end

    # Get Streamers for a series
    def get_streamers(type, ids)
      groupify StreamingLink.joins(:streamer).where(media_id: ids, media_type: type)
        .uniq.pluck(:media_id, 'streamers.site_name')
    end
  end

  define_type Anime.includes(:genres) do
    crutch(:people) { |coll| MediaIndex.get_people 'Anime', coll.map(&:id) }
    crutch(:characters) { |coll| MediaIndex.get_characters 'Anime', coll.map(&:id) }
    crutch(:streamers) { |coll| MediaIndex.get_streamers 'Anime', coll.map(&:id) }

    root date_detection: false do
      include IndexTranslatable

      # Titles and freeform text
      translatable_field :titles
      field :abbreviated_titles, type: 'string'
      field :synopsis, type: 'string', analyzer: 'english'
      # Enumerated values
      field :age_rating, :show_type, type: 'string'
      # Various Data
      field :episode_count, type: 'short' # Max of 32k or so is reasonable
      field :average_rating, type: 'float'
      field :start_date, :end_date, :created_at, type: 'date'
      field :season, type: 'string'
      field :year, type: 'short' # Update this before year 32,000
      field :genres, value: -> (a) { a.genres.map(&:name) }
      field :user_count, type: 'integer'
      # Castings
      field :people, value: -> (a, crutch) { crutch.people[a.id] }
      field :characters, value: -> (a, crutch) { crutch.characters[a.id] }
      # Where to watch
      field :streamers, value: -> (a, crutch) { crutch.streamers[a.id] }
    end
  end

  define_type Manga.includes(:genres) do
    crutch(:people) { |coll| get_people 'Anime', coll.map(&:id) }
    crutch(:characters) { |coll| get_characters 'Anime', coll.map(&:id) }

    root date_detection: false do
      include IndexTranslatable

      # Titles and freeform text
      translatable_field :titles
      field :abbreviated_titles, type: 'string'
      field :synopsis, type: 'string', analyzer: 'english'
      # Enumerated values
      field :manga_type, type: 'string'
      # Various Data
      field :chapter_count, type: 'integer' # Manga run for a really long time
      field :average_rating, type: 'float'
      field :start_date, :end_date, :created_at, type: 'date'
      field :year, type: 'short' # Update this before year 32,000
      field :genres, value: -> (a) { a.genres.map(&:name) }
      field :user_count, type: 'integer'
      # Castings
      field :people, value: -> (a, crutch) { crutch.people[a.id] }
      field :characters, value: -> (a, crutch) { crutch.characters[a.id] }
    end
  end
end
