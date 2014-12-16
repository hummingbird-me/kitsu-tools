import Em from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  source: DS.belongsTo('model', {polymorphic: true}),
  createdAt: DS.attr('date'),
  notificationType: DS.attr('string'),
  seen: DS.attr('boolean'),

  isProfileComment: Em.computed.equal('notificationType', "profile_comment"),
  isCommentReply: Em.computed.equal('notificationType', "comment_reply"),

  link: function() {
    return "/notifications/" + this.get('id');
  }.property('id'),

  sourceUser: Em.computed.any('source.poster', 'source.user')
});
