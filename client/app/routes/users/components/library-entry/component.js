import Component from 'ember-component';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import service from 'ember-service/inject';
import { task, timeout } from 'ember-concurrency';
import IsOwnerMixin from 'client/mixins/is-owner';
import jQuery from 'jquery';

export default Component.extend(IsOwnerMixin, {
  isExpanded: false,

  session: service(),
  i18n: service(),
  media: alias('entry.media'),
  user: alias('entry.user'),

  // TODO: Handle manga (no support yet?)
  totalProgress: computed('media.episodeCount', {
    get() {
      return get(this, 'media.episodeCount') || '-';
    }
  }).readOnly(),

  rating: computed('entry.rating', {
    get() {
      return get(this, 'entry.rating') || '-';
    }
  }).readOnly(),

  type: computed('media.{showType,mangaType}', {
    get() {
      const mediaType = get(this, 'mediaType');
      const key = mediaType === 'manga' ? 'manga-type' : 'show-type';
      const type = get(this, 'media.showType') || get(this, 'media.mangaType');
      return get(this, 'i18n').t(`media.${mediaType}.${key}.${type}`);
    }
  }).readOnly(),

  updateProperty: task(function *(key, value, shouldTimeout = true) {
    if (shouldTimeout === true) {
      yield timeout(1000);
    }
    yield get(this, 'update')(key, value);
  }).restartable(),

  /**
   * Toggle the `isExpanded` property when the component is clicked.
   * Returns early if the click is not within the desired container or
   * is within an input element.
   */
  click(event) {
    const target = get(event, 'target');
    const isChild = jQuery(target).is('.entry-wrapper *, .entry-wrapper');
    if (isChild === false || get(target, 'tagName') === 'INPUT') {
      return;
    }
    this.toggleProperty('isExpanded');
  },

  actions: {
    updateEntry(key, value) {
      get(this, 'update')(key, value);
    },

    deleteEntry() {
      get(this, 'delete')();
    },

    rewatch() {
      const reconsumeCount = get(this, 'entry.reconsumeCount') + 1;
      const updates = {
        reconsumeCount,
        progress: 0,
        status: 'current'
      };
      get(this, 'updateProperty').perform(updates);
    }
  }
});
