import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';

export default Ember.ObjectController.extend(ModalMixin, {
  youtubeEmbedURL: function () {
    return "https://www.youtube.com/embed/" + this.get('youtubeVideoId');
  }.property('youtubeVideoId')
});
