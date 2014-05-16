class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :cover_image_url,
             :avatar_template,
             :rating_type,
             :mini_bio,
             :is_followed,
             :title_language_preference,
             :online,
             :location,
             :website,
             :waifu,
             :waifu_or_husbando,
             :waifu_slug,
             :waifu_char_id,
             :last_sign_in_at,
             :current_sign_in_at

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
    scope ? !!object.follower_relations.detect {|x| x.follower_id == scope.id } : false
  end

  def include_title_language_preference?
    scope == object
  end

  def online
    object.online?
  end
end
