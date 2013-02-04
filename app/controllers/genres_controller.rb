class GenresController < ApplicationController
  def index
    @genres = params.keys.select {|x| params[x] == ".#{x}" }
                    .map {|x| x.gsub(/^g_/, "") }
    url = URI.parse request.env["HTTP_REFERER"]
    url.query = "genres=#{@genres*'+'}"
    redirect_to url.to_s
  end

  def show
    redirect_to anime_index_path(:genres => params[:id])
  end
end
