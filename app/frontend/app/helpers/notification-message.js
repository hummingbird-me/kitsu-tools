import Ember from 'ember';

export function notificationMessage(notificationObject) {
  if(notificationObject === undefined) { return; }

  var messageType = notificationObject.get('notificationType');
  var messageStore = {

    /* Old notification types! */
    profile_comment: '<user> wrote a post on your feed.',
    comment_reply: '<user> wrote a reply to your comment.',

    feed_post:          '<user> wrote a post on your feed.',
    feed_post_comment:  '<user> wrote a comment to your feed post.',
    feed_post_reply:    '<user> commented on a feed post you commented on.',
    feed_post_like:     '<user> liked your feed post.',
    user_follow:        '<user> followed you.'
  };

  if(messageStore[messageType] === undefined) { return "A cat probably ate this notification!"; }
  var msg = messageStore[messageType].replace('<user>',
    '<span class="who">'+notificationObject.get('sourceUser.username')+'</span>');

  return new Ember.Handlebars.SafeString(msg);
}

export default Ember.Handlebars.makeBoundHelper(notificationMessage);
