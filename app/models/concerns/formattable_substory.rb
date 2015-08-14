module FormattableSubstory
  extend ActiveSupport::Concern

  included do
    before_save do
      data.stringify_keys!

      formatter = MessageFormatter.new(data['comment'])
      data['formatted_comment'] = formatter.format

      # Notify users mentioned in the post, ignoring users already notified
      # by this post.
      mentions = formatter.mentions
      notified = Notification.feed_mention.where(source: self).pluck(:user_id)
      notified = User.find(notified)

      (mentions - notified).each do |mention|
        Notification.create(
          notification_type: 'feed_mention',
          user: mention,
          source: substory
        )
      end
    end
  end
end
