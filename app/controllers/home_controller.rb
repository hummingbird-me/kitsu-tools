class HomeController < ApplicationController
  def hide_cover_image
    @hide_cover_image = true
  end

  before_filter :hide_cover_image
  caches_action :index, layout: false, :if => lambda { not user_signed_in? }

  def index
    @latest_reviews = Review.order('created_at DESC').limit(2)

    @recent_anime_users = User.joins(:watchlists).order('MAX(watchlists.last_watched) DESC').group('users.id').limit(8)
    @recent_anime = @recent_anime_users.map {|x| x.watchlists.where("EXISTS (SELECT 1 FROM anime WHERE anime.id = anime_id AND age_rating <> 'Rx')").order('updated_at DESC').limit(1).first }.sort_by {|x| x.last_watched || x.updated_at }.reverse
    
    # Select one of these 9 background images.
    @background_image = %w[
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/076/original/blood.jpg?1361895445
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/074/original/another3.jpg?1361895288
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/072/original/another.jpg?1361895189
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/059/original/darker4.jpg?1361823103
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/058/original/darker3.jpg?1361823078
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/057/original/darker2.jpg?1361823056
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/056/original/darker.jpg?1361823028
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/136/original/melancholy.jpg?1362175820
      http://hakanai.vikhyat.net/system/gallery_images/images/000/000/137/original/melancholy3.jpg?1362175882
    ].sample
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
