class SearchController < ApplicationController
  def basic
    @anime = Anime.page(params[:page]).per(18)

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
    
    @anime = @anime.search(title: params[:query])

    render "anime/index"
  end
end
