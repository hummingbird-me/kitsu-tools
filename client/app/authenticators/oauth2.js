import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';
import config from 'client/config/environment';

export default OAuth2PasswordGrant.extend({
  refreshAccessTokens: true,
  serverTokenEndpoint: `${config.host}/oauth/token`,
  serverTokenRevocationEndpoint: `${config.host}/oauth/revoke`
});
