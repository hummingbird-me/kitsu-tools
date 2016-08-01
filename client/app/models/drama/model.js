import attr from 'ember-data/attr';
import Media from 'client/models/media/model';
import EpisodicMixin from 'client/mixins/models/episodic';

export default Media.extend(EpisodicMixin, {
  showType: attr('string'),
  youtubeVideoId: attr('string')
});
