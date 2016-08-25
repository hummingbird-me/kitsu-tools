import Route from 'ember-route';
import get from 'ember-metal/get';
import set, { setProperties } from 'ember-metal/set';
import { capitalize } from 'ember-string';
import service from 'ember-service/inject';
import { task } from 'ember-concurrency';
import libraryStatus from 'client/utils/library-status';
import PaginationMixin from 'client/mixins/routes/pagination';
import LibraryEntryMixin from 'client/mixins/routes/library-entry';
import jQuery from 'jquery';

export default Route.extend(PaginationMixin, LibraryEntryMixin, {
  queryParams: {
    media: { refreshModel: true },
    status: { refreshModel: true }
  },
  i18n: service(),

  /**
   * Restartable task that queries the library entries for the current status,
   * and media type.
   */
  modelTask: task(function *(media, status) {
    const user = this.modelFor('users');
    const userId = get(user, 'id');
    const options = {};

    if (status === 'all') {
      status = '1,2,3,4,5';
      Object.assign(options, { sort: 'status' });
    } else {
      status = libraryStatus.enumToNumber(status);
    }

    Object.assign(options, {
      include: 'media.genres,user',
      filter: {
        user_id: userId,
        media_type: capitalize(media),
        status
      },
      page: { offset: 0, limit: 50 }
    });
    return yield get(this, 'store').query('library-entry', options);
  }).restartable(),

  model({ media, status }) {
    return get(this, 'modelTask').perform(media, status);
  },

  titleToken() {
    const model = this.modelFor('users');
    const name = get(model, 'name');
    return get(this, 'i18n').t('titles.users.library', { user: name });
  },

  actions: {
    loading(transition) {
      const controller = this.controllerFor(get(this, 'routeName'));
      set(controller, 'isLoading', true);
      transition.promise.finally(() => set(controller, 'isLoading', false));
    },

    updateMedia(media) {
      const controller = this.controllerFor(get(this, 'routeName'));
      set(controller, 'media', media);
    },

    updateEntry(entry, key, value) {
      if (jQuery.isPlainObject(key)) {
        setProperties(entry, key);
      } else {
        set(entry, key, value);
      }

      if (get(entry, 'validations.isValid') === true) {
        return entry.save()
          .then(() => {
            // TODO: Feedback for user
          })
          .catch(() => entry.rollbackAttributes());
      }
    },

    deleteEntry(entry) {
      return entry.destroyRecord()
        .then(() => {
          // TODO: Feedback for user.
        })
        .catch(() => entry.rollbackAttributes());
    }
  }
});
