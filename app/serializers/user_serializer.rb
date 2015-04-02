class UserSerializer < ActiveModel::Serializer
  attributes :id, :cover_image_url, :avatar_template, :rating_type, :bio,
    :about, :is_followed, :title_language_preference, :location, :website,
    :waifu_or_husbando, :last_sign_in_at, :current_sign_in_at, :is_admin,
    :following_count, :follower_count, :is_pro, :about_formatted

  has_one :waifu, root: :characters

  def id
    object.name
  end

  def cover_image_url
    object.cover_image.url(:thumb)
  end

  def rating_type
    return 'fauna' if object.fauna_rating?
    object.star_rating? ? "advanced" : "simple"
  end

  def is_followed
    if object.is_followed.nil?
      scope ? !!object.follower_items.detect {|x| x.follower_id == scope.id } : false
    else
      object.is_followed
    end
  end

  def include_title_language_preference?
    scope == object
  end

  def is_admin
    object.admin?
  end

  def is_pro
    object.pro?
  end

  def follower_count
    object.followers_count_hack
  end
end
