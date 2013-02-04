class GenresController < ApplicationController
  def index
    @genres = params.keys.select {|x| params[x] == ".#{x}" }.uniq
                    .map {|x| x.gsub(/^g_/, "") }

    url = URI.parse request.env["HTTP_REFERER"]
    if @genres.length == Genre.count
      url.query = ""
    else
      url.query = "genres=#{@genres*'+'}"
    end
    redirect_to url.to_s
  end

  def show
    redirect_to anime_index_path(:genres => params[:id])
  end
end
