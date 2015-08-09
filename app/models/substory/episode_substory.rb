# == Schema Information
#
# Table name: substories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  story_id    :integer
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  type        :integer          default(0), not null
#  deleted_at  :datetime
#

class Substory
  class EpisodeSubstory < Substory
    def build(story, episode, service = nil)
      new({
        user: story.user,
        story: story,
        data: {
          episode_number: episode,
          service: service
        }.compact
      })
    end
  end
end
