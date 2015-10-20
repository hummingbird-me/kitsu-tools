import Ember from 'ember';
import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';
import getApiHost from 'client/utils/get-api-host';

const { computed } = Ember;

export default OAuth2PasswordGrant.extend({
  refreshAccessTokens: true,

  serverTokenEndpoint: computed(function() {
    return `${getApiHost()}/oauth/token`;
  }),

  serverTokenRevocationEndpoint: computed(function() {
    return `${getApiHost()}/oauth/revoke`;
  })
});
