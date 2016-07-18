import {
  avatar
} from 'frontend/helpers/avatar';

module('AvatarHelper');

// Replace this with your real tests.
test('avatar returns expected results', function() {
  var pattern = /src="(\S+)"/;
  var user = { avatarTemplate: '/default_avatar.jpg', get: function() { return this.avatarTemplate; } };
  var result = avatar(user, 'not_thumb');

  result = avatar(user, 'not_thumb');
  equal(result.string.match(pattern)[1], '/default_avatar.jpg');

  user.avatarTemplate = '/{size}/image.png?1234';
  result = avatar(user, 'not_thumb');
  equal(result.string.match(pattern)[1], '/not_thumb/image.jpg?1234');

  user.avatarTemplate = '/{size}/data?1234';
  result = avatar(user, 'not_thumb');
  equal(result.string.match(pattern)[1], '/not_thumb/data.jpg?1234');
});
