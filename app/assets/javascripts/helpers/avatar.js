Ember.Handlebars.helper('avatar', function(user, size) {
  var avatarUrl = user.get("avatarTemplate").replace('{size}', size);
  return new Handlebars.SafeString('<img class="responsive-image" src="' + avatarUrl + '" alt="' + user.get("username") + '">')
}, 'avatarTemplate', 'username');
