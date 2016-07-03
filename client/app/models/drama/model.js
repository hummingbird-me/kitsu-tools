import attr from 'ember-data/attr';
import Media from 'client/models/media/model';
import EpisodicModel from 'client/mixins/episodic-model';

export default Media.extend(EpisodicModel, {
  showType: attr('string'),
  youtubeVideoId: attr('string')
});
