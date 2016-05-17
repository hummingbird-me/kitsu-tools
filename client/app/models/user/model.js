import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { validator, buildValidations } from 'ember-cp-validations';
import service from 'ember-service/inject';
import get from 'ember-metal/get';

const Validations = buildValidations({
  email: [
    validator('presence', true),
    validator('format', {
      type: 'email',
      regex: /^[^@]+@([^@\.]+\.)+[^@\.]+$/
    })
  ],
  name: [
    validator('presence', true),
    validator('length', { min: 3, max: 20 }),
    validator('format', {
      regex: /^[_a-zA-Z0-9]+$/,
      message() {
        return get(this, 'model.i18n').t('errors.user.name.invalid').toString();
      }
    }),
    validator('format', {
      regex: /(?!^\d+$)^.+$/,
      message() {
        return get(this, 'model.i18n').t('errors.user.name.numbers').toString();
      }
    }),
    validator('format', {
      regex: /^[a-zA-Z0-9]/,
      message() {
        return get(this, 'model.i18n').t('errors.user.name.starts').toString();
      }
    })
  ],
  password: [
    validator('presence', true),
    validator('length', { min: 8 })
  ]
});

export default Model.extend(Validations, {
  i18n: service(),

  about: attr('string'),
  aboutFormatted: attr('string'),
  avatar: attr('string'),
  bio: attr('string'),
  coverImage: attr('string'),
  email: attr('string'),
  followersCount: attr('number'),
  followingCount: attr('number'),
  location: attr('string'),
  onboarded: attr('boolean'),
  password: attr('string'),
  pastNames: attr('array'),
  name: attr('string'),
  ratingSystem: attr('number'),
  toFollow: attr('boolean'),
  waifuOrHusbando: attr('string'),
  website: attr('string')
});
