class SearchController < ApplicationController
  STOP_WORDS = /season/i

  def search_database (type, query, page)
    model = case type
      when "anime" then Anime.page(page).per(20)
      when "manga" then Manga.page(page).per(20)
      when "character" then Character.page(page).per(20)
    end
    list = model.simple_search_by_title(query)
    list = model.fuzzy_search_by_title(query) if list.length == 0
    list
  end

  def basic

    @stype = params[:type] || "anime"
    @query = params[:query] || ""
    @page  = params[:page]

    case @stype
      when "anime"
        query = (@query || "").gsub(STOP_WORDS, '')
        found = search_database 'anime', query, @page

        # TODO: Re-write broken watchlist stuff here
        @results = found.map {|x| [x.title, x.alt_title] }.flatten.compact

      when "manga"
        query = (query || "").gsub(STOP_WORDS, '')
        @results = search_database 'manga', query, @page

      when "users"
        @results = User.search(@query).page(@page).per(20)

      when "users_to_follow"
        @results = User.search(@query).page(@page).per(20)

      when "character"
        @results = search_database 'character', @query, @page

      # Mixed search provides search results for the instant
      # search field in the page header.
      when "mixed"
        anime = search_database 'anime', @query, @page
        manga = search_database 'manga', @query, @page
        users = User.match(@query)
        users = User.search(@query) if users.length == 0

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

      # Full search provides search results for the search page
      # with more detailed information about anime, manga and users
      # as well as a direct library / following widget (<- not yet)
      when "full"
        anime = search_database 'anime', @query, @page
        manga = search_database 'manga', @query, @page
        users = User.search(@query)

        formattedAnime = anime.map do |x|
          {
            :id => x.id,
            :type => 'anime',
            :title => x.title,
            :desc => "#{x.synopsis[0..300].split(" ").to_a[0..-2].join(" ")}...",
            :image => x.poster_image_thumb,
            :link => "/anime/#{x.slug}",
            :badges => [
              {:class => 'anime', :content => "Anime"},
              {:class => 'episodes', :content => "#{x.show_type}, #{x.episode_count}"}
            ]
          }
        end
        formattedUsers = users.map { |x|
          {
            :type => 'user',
            :title => x.name,
            :desc => x.bio,
            :image => x.avatar_template,
            :link => "/users/#{x.name}",
            :badges => [
              {:class => 'user', :content => "User"}
            ]
          }
        }

        @results = [formattedAnime, formattedUsers].flatten

      else
        not_found!
    end

    respond_to do |format|
      format.html { render_ember }
      format.json { render :json => @results }
    end
  end
end
