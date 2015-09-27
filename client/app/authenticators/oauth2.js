import Ember from 'ember';
import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';
import config from 'client/config/environment';

const { computed } = Ember;

export default OAuth2PasswordGrant.extend({
  refreshAccessTokens: true,

  serverTokenEndpoint: computed(function() {
    return `${config.host}/oauth/token`;
  }),

  serverTokenRevocationEndpoint: computed(function() {
    return `${config.host}/oauth/revoke`;
  })
});
