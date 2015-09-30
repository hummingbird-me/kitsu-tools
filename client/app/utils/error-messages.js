import Ember from 'ember';

const { get, isPresent } = Ember;

// @Cleanup: Might be worth only showing a single error, rather than all. -vevix
export default function errorMessages(obj) {
  const reason = 'An unknown error occurred';
  let errors = get(obj, 'errors');
  errors = errors === undefined ? get(obj, 'jqXHR.responseJSON.errors') : errors;
  return isPresent(errors) ? errors.mapBy('title').compact().join('\n') : reason;
}
