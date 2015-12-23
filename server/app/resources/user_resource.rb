class UserResource < BaseResource
  PRIVATE_FIELDS = %i[email password]

  attributes :name, :past_names, :avatar, :cover_image, :about, :bio,
             :about_formatted, :location, :website, :waifu_or_husbando,
             :rating_system, :to_follow, :followers_count, :following_count,
             :onboarded

  attributes *PRIVATE_FIELDS

  filter :name, apply: -> (records, value, _o) { records.by_name(value.first) }
  filter :self, apply: -> (_r, _v, options) {
    current_user = options[:context][:current_user]
    records.where(id: current_user.try(:id)) || User.none
  }

  def fetchable_fields
    if current_user == _model
      super
    else
      super - PRIVATE_FIELDS
    end
  end
end
