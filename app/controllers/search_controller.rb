class SearchController < ApplicationController
  def basic
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
        if user_signed_in? and (current_user.email == "c@vikhyat.net" or current_user.email == "josh@hummingbird.ly")
          render "anime", layout: "layouts/search"
        else
          @collection = @anime.map {|x| [x, @watchlist[x.id]] }
          render "anime/index", layout: "layouts/application"
        end
      }
      format.json {
        render :json => @anime.map {|x| [x.title, x.alt_title] }.flatten.compact
      }
    end
  end
end
