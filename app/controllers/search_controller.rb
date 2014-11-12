class SearchController < ApplicationController
  STOP_WORDS = /season/i

  def search_database(type, query, page, perpage = 20)
    return [] if query.length < 3
    model = case type
      when "anime" then Anime.page(page).per(perpage).sfw_filter(current_user)
      when "manga" then Manga.page(page).per(perpage)
      when "character" then Character.page(page).per(perpage)
    end
    list = model.simple_search_by_title(query)
    list = model.fuzzy_search_by_title(query) if list.length == 0
    list
  end

  def basic
    @stype = params[:type] || "anime"
    @query = params[:query] || ""
    @page  = params[:page]

    respond_to do |format|
      format.html { render_ember }
      format.json do
        if self.methods.to_s.include? 'search_'+@stype
          self.send('search_'+@stype)
        else
          not_found!
        end
      end
    end
  end

  def search_anime
    query = (@query || "").gsub(STOP_WORDS, '')
    found = search_database 'anime', query, @page
    @results = found.map {|x| [x.title, x.alt_title] }.flatten.compact
    render json: @results
  end

  def search_manga
    query = (query || "").gsub(STOP_WORDS, '')
    @results = search_database 'manga', query, @page
    render json: @results
  end

  def search_users
    @results = User.search(@query).page(@page).per(20)
    render json: @results
  end

  def search_users_to_follow
    search_users
  end

  def search_character
    @results = search_database 'character', @query, @page
    render json: @results
  end

  def search_mixed
    anime = search_database 'anime', @query, @page
    manga = search_database 'manga', @query, @page
    users = User.match(@query)
    users = User.search(@query).page(1).per(20) if users.length == 0

    formattedAnime = anime.map { |x|
      {:type => 'anime', :title => x.title, :image => x.poster_image_thumb, :link => "/anime/#{x.slug}" }
    }.flatten
    formattedManga = manga.map { |x|
      {:type => 'manga', :title => x.romaji_title, :image => x.poster_image_thumb, :link => "/manga/#{x.slug}" }
    }.flatten
    formattedUsers = users.map { |x|
      {:type => 'user', :title => x.name, :image => x.avatar_template, :link => "/users/#{x.name}" }
    }.flatten

    @results = [formattedAnime.take(3), formattedManga.take(3), formattedUsers.take(2)].flatten
    render json: @results
  end

  def search_full
    anime = search_database 'anime', @query, @page, 30
    manga = search_database 'manga', @query, @page, 30
    users = User.search(@query).page(1).per(20)

    formattedAnime = anime.map do |x| {
      :type => 'anime',
      :title => x.title,
      :desc => "#{x.synopsis[0..300].split(" ").to_a[0..-2].join(" ")}...",
      :image => x.poster_image_thumb,
      :link => x.slug,
      :badges => [
        {:class => 'anime', :content => "Anime"},
        {:class => 'episodes', :content => "#{x.episode_count}ep &bull; #{x.episode_length}min"},
        {:class => 'episodes', :content => "#{x.show_type} &bull; #{x.age_rating}"}
      ]}
    end
    formattedManga = manga.map do |x| {
      :type => 'manga',
      :title => x.romaji_title,
      :desc => "#{x.synopsis[0..300].split(" ").to_a[0..-2].join(" ")}...",
      :image => x.poster_image_thumb,
      :link => x.slug,
      :badges => [
        {:class => 'manga', :content => "Manga"},
        {:class => 'episodes', :content => "#{x.volume_count || "?"}vol &bull; #{x.chapter_count || "?"}chap"}
      ]}
    end
    formattedUsers = users.map do |x| {
      :type => 'user',
      :title => x.name,
      :desc => x.bio,
      :image => x.avatar_url,
      :link => x.name,
      :badges => [
        {:class => 'user', :content => "User"}
      ]}
    end

    @results = [formattedAnime, formattedManga, formattedUsers].flatten
    render json: @results
  end

  def search_element
    unless params[:datatype].nil?
      @type = params[:datatype]
      if @type == "anime"
        @results = search_database 'anime', @query, 1, 20
        render json: @results, each_serializer: AnimeSerializer
      else
        @results = search_database 'manga', @query, 1, 20
        render json: @results, each_serializer: MangaSerializer
      end
    else
      not_found!
    end
  end
end
