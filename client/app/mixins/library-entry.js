import Mixin from 'ember-metal/mixin';
import get from 'ember-metal/get';
import service from 'ember-service/inject';
import { capitalize } from 'ember-string';

export default Mixin.create({
  store: service(),

  _getLibraryEntry(media) {
    if (get(this, 'currentSession.isAuthenticated') === false) {
      return;
    }

    return get(this, 'store').query('library-entry', {
      filter: {
        user_id: get(this, 'currentSession.account.id'),
        media_type: capitalize(media.constructor.modelName),
        media_id: get(media, 'id')
      }
    });
  }
});
