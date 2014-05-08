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

    # What are we searching for?
    @search_type = params[:type] || "anime"

    if @search_type == "anime"
      query = (params[:query] || "").gsub(STOP_WORDS, '')
      @results = search_database 'anime', query, params[:page]

      @watchlist_status = {}
      if user_signed_in?
        current_user.watchlists.where(anime_id: @results.map {|x| x.id }).each do |w|
          @watchlist_status[w.anime_id] = w.status
        end
      end

      respond_to do |format|
        format.html { render "anime" }
        format.json { render :json => @results.map {|x| [x.title, x.alt_title] }.flatten.compact }
      end



    elsif @search_type == "manga"
      query = (params[:query] || "").gsub(STOP_WORDS, '')
      @results = search_database 'manga', query, params[:page]

      respond_to do |format|
        format.html { render :manga }
      end



    elsif @search_type == "users"
      @results = User.search(params[:query] || "askdhjfg").page(params[:page]).per(20)
      render "users"

    elsif @search_type == "users_to_follow"
      @results = User.search(params[:query] || "askdhjfg").page(params[:page]).per(20)
      render json: @results
      #respond_to do |format|
      #  format.json { render :json => @results.map {|x| {:id => x.id, :name => x.name} }.flatten.compact }
      #end

    elsif @search_type == "character"
      @results = search_database 'character', params[:query], params[:page]

      respond_to do |format|
        format.json { render :json => @results.map {|x| {:id => x.id, :name => x.name} }.flatten.compact }
      end



    # Mixed search for the instant search form in the header.
    # This will only return minimal data about anime and users
    elsif @search_type == "mixed"
      anime = search_database 'anime', params[:query], params[:page]
      users = User.match(params[:query])
      users = User.search(params[:query]) if users.length == 0

      formattedAnime = anime.map { |x|
        {:type => 'anime', :title => x.title, :image => x.poster_image_thumb, :link => "/anime/#{x.slug}" }
      }.flatten
      formattedUsers = users.map { |x|
        {:type => 'user', :title => x.name, :image => x.avatar_template, :link => "/users/#{x.name}" } 
      }.flatten

      respond_to do |format|
        format.json { render :json => [formattedAnime, formattedUsers].flatten }
      end


    # Mixed full search for the instant search form on the search page
    # This will return all information about an anime or user
    elsif @search_type == "full"
      anime = search_database 'anime', params[:query], params[:page]
      users = User.search(params[:query]).limit(20)

      watchlist_status = {}
      if user_signed_in?
        current_user.watchlists.where(anime_id: anime.map {|x| x.id }).each do |w|
          watchlist_status[w.anime_id] = w.status
        end
      end

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

      respond_to do |format|
        format.json { render :json => [formattedAnime, formattedUsers, watchlist_status].flatten }
      end

    else
      not_found!
    end
  end
end
