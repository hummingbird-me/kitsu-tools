class UserSerializer < ActiveModel::Serializer
  attributes :id, :cover_image_url, :avatar_template, :rating_type, :mini_bio,
    :about, :is_followed, :title_language_preference, :location, :website,
    :waifu, :waifu_or_husbando, :waifu_slug, :waifu_char_id, :last_sign_in_at,
    :current_sign_in_at, :is_admin, :following_count, :follower_count, :is_pro,
    :to_follow

  def id
    object.name
  end

  def cover_image_url
    object.cover_image.url(:thumb)
  end

  def rating_type
    object.star_rating? ? "advanced" : "simple"
  end

  def mini_bio
    object.bio
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
