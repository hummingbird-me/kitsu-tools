import MediaIndexRoute from 'client/routes/media/index/route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';

export default MediaIndexRoute.extend({
  mediaType: 'anime',
  queryParams: {
    ageRating: { refreshModel: true, replace: true },
    episodeCount: { replace: true },
    streamers: { refreshModel: true, replace: true }
  },

  beforeModel() {
    this._super(...arguments);
    return get(this, 'store').query('streamer', {
      page: { offset: 0, limit: 20000 }
    }).then((results) => {
      const controller = this.controllerFor(get(this, 'routeName'));
      set(controller, 'availableStreamers', results);
    });
  }
});
