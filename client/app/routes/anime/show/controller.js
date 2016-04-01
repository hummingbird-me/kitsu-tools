import Controller from 'ember-controller';
import { alias } from 'ember-computed';
import service from 'ember-service/inject';

export default Controller.extend({
  anime: alias('model'),
  currentSession: service()
});
