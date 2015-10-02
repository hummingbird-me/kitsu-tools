import Ember from 'ember';

const { get, isPresent, isArray } = Ember;
// http://tools.ietf.org/html/rfc6749#section-5.2
const lookupTable = {
  'invalid_grant': 'The provided credentials are not valid.'
};

function formatErrors(errors) {
  errors = errors.map((error) => {
    const param = get(error, 'source.parameter');
    if (param === undefined) {
      return get(error, 'title');
    }
    return `${param.capitalize()} ${get(error, 'title')}`;
  });
  return errors.compact().join('\n');
}

// @Cleanup: Might be worth only showing a single error, rather than all. -vevix
export default function errorMessages(obj) {
  let reason = 'An unknown error occurred';
  let errors = get(obj, 'errors') || get(obj, 'error');
  errors = errors === undefined ? get(obj, 'jqXHR.responseJSON.errors') : errors;
  if (isPresent(errors)) {
    reason = isArray(errors) ? formatErrors(errors) : get(lookupTable, errors);
  }
  return reason;
}
