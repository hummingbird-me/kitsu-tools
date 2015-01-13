class FavoritesController < ApplicationController
  
  def index
    not_found! if params[:user_id].nil? || params[:type].nil?

    @favs = User.find(params[:user_id]).favorites
    @favs = @favs.where(:item_type => params[:type]).order(:fav_rank).all
    render json: @favs, each_serializer: FavoriteSerializer
  end

  def update
  end

end
