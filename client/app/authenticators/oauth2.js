import computed from 'ember-computed';
import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';
import getApiHost from 'client/utils/get-api-host';

export default OAuth2PasswordGrant.extend({
  refreshAccessTokens: true,

  serverTokenEndpoint: computed({
    get() {
      const host = getApiHost();
      return `${host}/oauth/token`;
    }
  }),

  serverTokenRevocationEndpoint: computed({
    get() {
      const host = getApiHost();
      return `${host}/oauth/revoke`;
    }
  })
});
