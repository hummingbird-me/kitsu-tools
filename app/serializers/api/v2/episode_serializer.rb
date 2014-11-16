module Api::V2
  class EpisodeSerializer < Serializer
    title :episode

    fields :title, :synopsis, :airdate, :number, :season_number
  end
end
