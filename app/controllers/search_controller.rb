class SearchController < ApplicationController
  def basic
    @anime = Anime.sfw_filter(current_user).page(params[:page]).per(18)

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
    
    @anime = @anime.search_by_title(params[:query])
    @collection = @anime.map {|x| [x, @watchlist[x.id]] }

    render "anime/index"
  end
end
