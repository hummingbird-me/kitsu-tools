import get from 'ember-metal/get';
import { isPresent } from 'ember-utils';
import { isEmberArray } from 'ember-array/utils';
import { capitalize } from 'ember-string';

// http://tools.ietf.org/html/rfc6749#section-5.2
const lookupTable = {
  'invalid_grant': 'The provided credentials are invalid.'
};

export default function errorMessages(obj) {
  let reason = 'An unknown error occurred';
  let errors = get(obj, 'errors') || get(obj, 'error');
  errors = errors === undefined ? get(obj, 'jqXHR.responseJSON.errors') : errors;
  if (isPresent(errors)) {
    reason = isEmberArray(errors) ? capitalize(get(errors[0], 'detail')) : get(lookupTable, errors);
  }
  return reason;
}
