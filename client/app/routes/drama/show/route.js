import Route from 'ember-route';
import MediaShowRoute from 'client/mixins/routes/media-show-route';
import CanonicalUrlRedirectMixin from 'client/mixins/routes/canonical-url-redirect';

export default Route.extend(MediaShowRoute, CanonicalUrlRedirectMixin, {
  mediaType: 'drama'
});
