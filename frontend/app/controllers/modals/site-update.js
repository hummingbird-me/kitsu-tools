import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';

export default Ember.Controller.extend(ModalMixin, {
  actions: {
    refresh: function() {
      window.location.reload();
    }
  }
});
