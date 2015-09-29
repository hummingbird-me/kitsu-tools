class GenresController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @genres = params.keys.select { |x| params[x] == ".#{x}" }.uniq
                  .map { |x| x.gsub(/^g_/, '') }

        url = URI.parse request.env['HTTP_REFERER']
        if @genres == Genre.default_filterable(current_user).map(&:slug)
          url.query = ''
        else
          url.query = "genres=#{@genres * '+'}"
        end
        redirect_to url.to_s
      end

      format.json do
        render json: Genre.default_filterable(current_user)
      end
    end
  end

  def show
    redirect_to anime_filter_path(g: [params[:id]])
  end

  def add_to_favorites
    authenticate_user!
    @genre = Genre.find params[:genre_id]
    unless current_user.favorite_genres.include? @genre
      current_user.favorite_genres.push @genre
      current_user.update_column :last_library_update, Time.now
    end
    render json: true
  end

  def remove_from_favorites
    authenticate_user!
    @genre = Genre.find params[:genre_id]
    if current_user.favorite_genres.include? @genre
      current_user.favorite_genres.delete @genre
      current_user.update_column :last_library_update, Time.now
    end
    render json: true
  end
end
