# This implements the feed users see on their homepages.

class UserTimeline
  def self.fetch(user, options={})
    page = options[:page] || 1
    ability = Ability.new user
    stories = Story.accessible_by(ability).order('updated_at DESC').where(user_id: user.following.map {|x| x.id } + [user.id]).page(page).includes(:substories).per(20)
    Entities::Story.represent(stories, current_ability: ability, title_language_preference: user.title_language_preference).to_json
  end
end
