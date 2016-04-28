import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';

export default OAuth2PasswordGrant.extend({
  refreshAccessTokens: true,
  serverTokenEndpoint: '/api/oauth/token',
  serverTokenRevocationEndpoint: '/api/oauth/revoke'
});
