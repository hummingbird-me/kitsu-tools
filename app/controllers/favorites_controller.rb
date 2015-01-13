class FavoritesController < ApplicationController
  
  def index
    not_found! if params[:user_id].nil? || params[:type].nil?

    @favs = User.find(params[:user_id]).favorites
    @favs = @favs.where(:item_type => params[:type]).order(:fav_rank).all
    render json: @favs, each_serializer: FavoriteSerializer
  end

  def create

    # Switch creating favorites to this endpoint
    # for the future?

    render json: false
  end

  def destroy
    authenticate_user!
    params.require(:id)

    Favorite.find(params[:id]).destroy!

    render json: true
  end

  def update_all
  end

end
