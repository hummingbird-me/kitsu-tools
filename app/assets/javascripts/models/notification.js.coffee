Hummingbird.Notification = DS.Model.extend
  source_type: DS.attr('string')
  source_user: DS.attr('string')
  created_at: DS.attr('date')
  notification_type: DS.attr('profile_comment')
  seen: DS.attr('boolean')