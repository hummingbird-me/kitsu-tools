class SearchController < ApplicationController
  STOP_WORDS = /season/i

  def basic

    # What are we searching for?
    @search_type = params[:type] || "anime"

    if @search_type == "anime"

      query = (params[:query] || "").gsub(STOP_WORDS, '')

      @anime = Anime.accessible_by(current_ability).page(params[:page]).per(20)
      @anime_list = @anime.simple_search_by_title(query)
      if @anime_list.length == 0
        @anime_list = @anime.fuzzy_search_by_title(query)
      end
      @results = @anime_list

      @watchlist_status = {}
      if user_signed_in?
        current_user.watchlists.where(anime_id: @results.map {|x| x.id }).each do |w|
          @watchlist_status[w.anime_id] = w.status
        end
      end

      respond_to do |format|
        format.html { render_ember }
        format.json { render :json => @results.map {|x| [x.title, x.alt_title] }.flatten.compact }
      end

    elsif @search_type == "manga"

      query = (params[:query] || "").gsub(STOP_WORDS, '')

      @manga = Manga.page(params[:page]).per(20)
      @manga_list = @manga.simple_search_by_title(query)
      if @manga_list.count == 0
        @manga_list = @manga.fuzzy_search_by_title(query)
      end
      @results = @manga_list

      respond_to do |format|
        format.html { render :manga }
      end

    elsif @search_type == "users"

      @results = User.search(params[:query] || "askdhjfg").page(params[:page]).per(20)
      render "users"

    elsif @search_type == "character"

      @char_list = Character.simple_search_by_name(params[:query])
      if @char_list.length == 0
        @char_list = Character.fuzzy_search_by_name(params[:query])
      end
      @results = @char_list

      respond_to do |format|
        format.json { render :json => @results.map {|x| {:id => x.id, :name => x.name} }.flatten.compact }
      end

    # Mixed search for autocomplete. Currently supports anime and users
    elsif @search_type == "mixed"
      anime = Anime.simple_search_by_title(params[:query])
      anime = Anime.fuzzy_search_by_title(params[:query]) if anime.length == 0
      users = User.search(params[:query])[0..1]

      formattedAnime = anime.map { |x|
        {:type => 'anime', :title => x.title, :image => x.poster_image_thumb, :link => "/anime/#{x.slug}" }
      }.flatten
      formattedUsers = users.map { |x|
        {:type => 'user', :title => x.name, :image => x.avatar_template, :link => "/users/#{x.name}" } 
      }.flatten

      respond_to do |format|
        format.json { render :json => [formattedAnime, formattedUsers].flatten }
      end

    else

      not_found!

    end

  end
end
