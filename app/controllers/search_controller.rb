class SearchController < ApplicationController
  def basic
    if true # user_signed_in? and (current_user.email == "c@vikhyat.net" or current_user.email == "josh@hummingbird.ly")

      # What are we searching for?
      @search_type = params[:type] || "anime"
      
      if @search_type == "anime"

        @anime = Anime.accessible_by(current_ability).page(params[:page]).per(20)
        @anime_list = @anime.simple_search_by_title(params[:query])
        if @anime_list.length == 0
          @anime_list = @anime.fuzzy_search_by_title(params[:query])
        end
        @results = @anime_list

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

      elsif @search_type == "forum-posts"

        @results = Forem::Post.search(:include => [:user, :topic]) do
          fulltext params[:query]
          paginate :page => (params[:page] || 1)
        end.results
        
        render "forum_posts"
        
      elsif @search_type == "users"

        @results = User.search do
          fulltext params[:query]
          paginate :page => (params[:page] || 1)
        end.results
        
        render "users"
        
      end
      
    else
      
      @anime = Anime.accessible_by(current_ability).page(params[:page]).per(18)

      @all_genres = Genre.order(:name)

      # Filter by genre if needed.
      if params[:genres] and params[:genres].length > 0
        @genre_slugs  = params[:genres].split.uniq 
        if @all_genres.count > @genre_slugs.length
          @genre_filter = Genre.where("slug IN (?)", @genre_slugs)
          @anime = @anime.joins(:genres)
                         .where("genres.id IN (?)", @genre_filter.map(&:id))
        end
      end
      @genre_filter ||= @all_genres

      # Fetch the user's watchlist.
      if user_signed_in?
        @watchlist = current_user.watchlist_table
      else
        @watchlist = Hash.new(false)
      end
      
      @anime_list = @anime.simple_search_by_title(params[:query])
      if @anime_list.length == 0
        @anime_list = @anime.fuzzy_search_by_title(params[:query])
      end
      @anime = @anime_list

      respond_to do |format|
        format.html {
          @collection = @anime.map {|x| [x, @watchlist[x.id]] }
          render "anime/index", layout: "layouts/application"
        }
        format.json {
          render :json => @anime.map {|x| [x.title, x.alt_title] }.flatten.compact
        }
      end
    end
  end
end
