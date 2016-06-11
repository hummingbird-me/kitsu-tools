import Ember from 'ember';

export function avatar(user, size) {
  var avatarUrl = user.get("avatarTemplate").replace('{size}', size);
  if (size !== "thumb") {
    const pattern = /\.[a-zA-Z]+\?/;
    // handle Facebook/weird case
    if (avatarUrl.match(pattern) !== null) {
      avatarUrl = avatarUrl.replace(pattern, '.jpg?');
    } else {
      avatarUrl = avatarUrl.split('?');
      avatarUrl = `${avatarUrl[0]}.jpg?${avatarUrl[1]}`;
    }
  }
  return new Ember.Handlebars.SafeString('<img class="responsive-image" src="' + avatarUrl + '" alt="' + user.get("username") + '">');
}

Ember.Handlebars.helper("avatar", avatar, 'avatarTemplate', 'username');
