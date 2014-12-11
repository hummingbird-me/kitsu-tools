import Ember from 'ember';

export function avatar(user, size) {
  var avatarUrl = user.get("avatarTemplate").replace('{size}', size);
  if (size !== "thumb") {
    avatarUrl = avatarUrl.replace(/\.[a-zA-Z]+\?/, '.jpg?');
  }

  return new Ember.Handlebars.SafeString('<img class="responsive-image" src="' + avatarUrl + '" alt="' + user.get("username") + '">');
}

Ember.Handlebars.helper("avatar", avatar, 'avatarTemplate', 'username');
