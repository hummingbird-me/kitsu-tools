import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';
import VersionableMixin from '../../mixins/modals/versionable';
/* global moment */

export default Ember.ObjectController.extend(ModalMixin, VersionableMixin, {
  startingDate: Ember.computed('startedAiring', function(k, v) {
    if (v !== undefined) {
      var date = new Date(v);
      if (!isNaN(date.getTime()) && /^[0-9]{4}-[0-9]{2}-[0-9]{2}/.test(v)) {
        this.set('startedAiring', date);
      }
    }
    return moment(this.get('startedAiring')).format('YYYY-MM-DD');
  }),

  finishedDate: Ember.computed('finishedAiring', function(k, v) {
    if (v !== undefined) {
      var date = new Date(v);
      if (!isNaN(date.getTime()) && /^[0-9]{4}-[0-9]{2}-[0-9]{2}/.test(v)) {
        this.set('finishedAiring', date);
      }
    }
    return moment(this.get('finishedAiring')).format('YYYY-MM-DD');
  })
});
