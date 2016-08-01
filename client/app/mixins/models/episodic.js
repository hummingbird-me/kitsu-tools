import Mixin from 'ember-metal/mixin';
import attr from 'ember-data/attr';

export default Mixin.create({
  episodeCount: attr('number'),
  episodeLength: attr('number')
});
