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
  class StatusSubstory < Substory
    def self.build(story, old, new, service=nil)
      new({
        user: story.user,
        story: story,
        data: {
          old_status: old,
          new_status: new,
          service: service
        }.compact
      })
    end

    def old_status
      data.old_status
    end

    def new_status
      data.new_status
    end

    def service
      data.service
    end
  end
end
