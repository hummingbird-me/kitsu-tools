import Route from 'ember-route';
import MediaShowRoute from 'client/mixins/media-show-route';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

export default Route.extend(MediaShowRoute, CanonicalUrlRedirect, {
  mediaType: 'drama'
});
