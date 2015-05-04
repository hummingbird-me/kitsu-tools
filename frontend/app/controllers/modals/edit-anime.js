import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';
import VersionableMixin from '../../mixins/modals/versionable';
/* global moment */

export default Ember.Controller.extend(ModalMixin, VersionableMixin, {
  startingDate: Ember.computed('model.startedAiring', function(k, v) {
    if (v !== undefined) {
      var date = new Date(v);
      if (!isNaN(date.getTime()) && /^[0-9]{4}-[0-9]{2}-[0-9]{2}/.test(v)) {
        this.set('model.startedAiring', date);
      }
    }
    return moment(this.get('model.startedAiring')).format('YYYY-MM-DD');
  }),

  finishedDate: Ember.computed('model.finishedAiring', function(k, v) {
    if (v !== undefined) {
      var date = new Date(v);
      if (!isNaN(date.getTime()) && /^[0-9]{4}-[0-9]{2}-[0-9]{2}/.test(v)) {
        this.set('model.finishedAiring', date);
      }
    }
    return moment(this.get('model.finishedAiring')).format('YYYY-MM-DD');
  })
});
