import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';

export default OAuth2PasswordGrant.extend({
  serverTokenEndpoint: '/oauth/token',
  serverTokenRevocationEndpoint: '/oauth/revoke',
  refreshAccessTokens: true
});
