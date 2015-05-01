import Ember from 'ember';

export default Ember.Mixin.create({
  coverUpload: Ember.Object.create(),
  coverUrl: Ember.computed.any('coverUpload.croppedImage', 'model.coverImageUrl'),
  coverImageStyle: function() {
    return (`background-image: url("${this.get('coverUrl')}")`).htmlSafe();
  }.property('coverUrl'),

  actions: {
    coverSelected: function(file) {
      var reader = new FileReader();
      reader.onload = (e) => {
        this.set('coverUpload.originalImage', e.target.result);
        this.send('openModal', 'crop-cover', this.get('coverUpload'));
      };
      reader.readAsDataURL(file);
    }
  }
});
