class FavoritesController < ApplicationController
  
  def index
    not_found! if params[:user_id].nil? || params[:type].nil?

    favs = User.find(params[:user_id]).favorites
    favs = favs.where(:item_type => params[:type]).order(:fav_rank).all
    render json: favs, each_serializer: FavoriteSerializer
  end

  def create

    # Switch creating favorites to this endpoint
    # for the future?

    render json: false
  end

  def destroy
    authenticate_user!
    params.require(:id)

    favorite = Favorite.find(params[:id])
    if favorite.user == current_user
      favorite.destroy!
    else
        error!("Unauthorized", 403)
    end

    render json: true
  end

  def update_all
    faves_hash = JSON.parse(params.require(:favorites))
    # This looks odd to do Hash[map { return [k,v] }] but it's a common pattern in Ruby, to map a hash
    faves_hash = Hash[faves_hash.map {|item| [item['id'], item['rank']] }]

    faves = Favorite.find(faves_hash.keys)

    ActiveRecord::Base.transaction do
      faves.each do |fave|
        if fave.user == current_user
          fave.update_attributes(fav_rank: faves_hash[fave.id.to_s])
        else
          # You need to return from here so that it doesn't continue looping
          error! "Unauthorized", 403
          return
        end
      end
    end

    render json: true
  end

end
