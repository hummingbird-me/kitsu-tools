import MediaShowRoute from 'client/routes/media/show/route';
import CanonicalUrlRedirectMixin from 'client/mixins/routes/canonical-url-redirect';

export default MediaShowRoute.extend(CanonicalUrlRedirectMixin, {
  mediaType: 'manga'
});
