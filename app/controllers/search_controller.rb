class SearchController < ApplicationController
  STOP_WORDS = /season/i
  SEARCH_SCOPES = {
    'all' => [Anime, Manga, Group, User],
    'anime' => [Anime],
    'manga' => [Manga],
    'groups' => [Group],
    'users' => [User],
    'characters' => [Character]
  }

  def search
    respond_to do |format|
      format.json do
        query = params.require(:query)

        # The cheap price of supporting Tenpenchii and Deadman
        if params[:type] == 'full' || !params.key?(:scope)
          scope = 'all'
          depth = 'instant'
        else
          scope = params.require(:scope)
          depth = params.require(:depth)
        end

        return error! "Invalid scope", 422 unless SEARCH_SCOPES.include?(scope)
        return error! "Invalid depth", 422 unless %w[instant full element].include?(depth)

        search_method = (depth + '_search').to_sym
        scopes = SEARCH_SCOPES[scope]

        results = self.send(search_method, scopes, query)

        # Alternate Ending
        # TODO: unify this stuff with the normal search stuff somehow
        if depth == 'element'
          if scope == 'anime'
            render json: results, each_serializer: AnimeSerializer
          elsif scope == 'manga'
            render json: results, each_serializer: MangaSerializer
          else
            error! "Scope isn't implemented for element search", 501
          end
          return
        end

        results = results.map do |x|
          presenter = ('present_' + x.class.name.downcase).to_sym
          self.send(presenter, x)
        end

        if depth == 'instant'
          results.each { |x| x[:image] = x[:image].url(:medium) }
        end

        return error! "No results", 404 if results.count == 0

        render json: results.as_json
      end
      format.html do
        render_ember
      end
    end
  end

  private
  def instant_search(scopes, query)
    query.gsub!(STOP_WORDS, '')
    results = scopes.map { |k| k.instant_search(query).limit(3) }.flatten
      .sort { |a, b| b.pg_search_rank <=> a.pg_search_rank }

    if results.length > 0
      results
    else
      full_search(scopes, query)
    end
  end
  alias_method :element_search, :instant_search

  def full_search(scopes, query)
    query.gsub!(STOP_WORDS, '')
    scopes.map { |k| k.full_search(query).limit(7) }.flatten
      .sort { |a, b| b.pg_search_rank <=> a.pg_search_rank }
  end

  # Presenters
  def present_manga(manga)
    {
      type: 'manga',
      title: manga.canonical_title,
      desc: manga.synopsis,
      image: manga.poster_image,
      link: manga.slug,
      rank: manga.pg_search_rank,
      badges: [
        { class: 'manga', content: "Manga" },
        { class: 'episodes', content: "#{manga.volume_count || "?"}vol &bull; #{manga.chapter_count || "?"}chap" }
      ]
    }
  end

  def present_anime(anime)
    {
      type: 'anime',
      title: anime.canonical_title(current_user),
      desc: anime.synopsis,
      image: anime.poster_image,
      link: anime.slug,
      rank: anime.pg_search_rank,
      badges: [
        { class: 'anime', content: "Anime" },
        { class: 'episodes', content: "#{anime.episode_count}ep &bull; #{anime.episode_length}min" },
        { class: 'episodes', content: "#{anime.show_type} &bull; #{anime.age_rating}" }
      ]
    }
  end

  def present_character(character)
    {
      type: 'character',
      title: character.name,
      desc: character.description,
      image: character.image,
      link: character.id.to_s,
      rank: character.pg_search_rank,
      badges: [
        { class: 'character', content: "Character" },
      ]
    }
  end

  def present_group(group)
    {
      type: 'group',
      title: group.name,
      desc: group.bio,
      image: group.avatar,
      link: group.slug,
      rank: group.pg_search_rank,
      badges: [
        { class: 'group', content: "Group" }
      ]
    }
  end

  def present_user(user)
    {
      type: 'user',
      title: user.name,
      desc: user.bio,
      image: user.avatar,
      link: user.name,
      rank: user.pg_search_rank,
      badges: [
        { class: 'user', content: "User" }
      ]
    }
  end
end
