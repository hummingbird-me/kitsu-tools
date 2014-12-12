import Ember from 'ember';

export default Ember.Mixin.create({
  actions: { close: function () {
      return this.send('closeModal');
    }
  }
});
