import Ember from 'ember';

const {
  Controller,
  computed: { alias },
  inject: { service }
} = Ember;

export default Controller.extend({
  anime: alias('model'),
  currentSession: service()
});
