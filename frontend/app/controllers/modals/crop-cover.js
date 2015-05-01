import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';

export default Ember.Controller.extend(ModalMixin, {
  actions: {
    upload: function() {
      this.send("uploadCover", this.get('model.croppedImage'));
      return this.send("closeModal");
    }
  }
});
