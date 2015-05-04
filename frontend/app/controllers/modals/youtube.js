import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';

export default Ember.Controller.extend(ModalMixin, {
  youtubeEmbedURL: function () {
    return "https://www.youtube.com/embed/" + this.get('model.youtubeVideoId');
  }.property('model.youtubeVideoId')
});
