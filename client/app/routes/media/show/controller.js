import Controller from 'ember-controller';
import { alias } from 'ember-computed';
import service from 'ember-service/inject';
import getter from 'client/utils/getter';

export default Controller.extend({
  media: alias('model'),
  session: service(),
  mediaType: getter(function() {
    return this.get('media').constructor.modelName;
  })
});
