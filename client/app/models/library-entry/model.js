import attr from 'ember-data/attr';
import Model from 'ember-data/model';
import { belongsTo } from 'ember-data/relationships';
import { validator, buildValidations } from 'ember-cp-validations';

const Validations = buildValidations({
  progress: [
    validator('presence', true),
    validator('number', {
      integer: true,
      gte: 0
    })
  ],
  reconsumeCount: [
    validator('presence', true),
    validator('number', {
      integer: true,
      gte: 0
    })
  ]
});

export default Model.extend(Validations, {
  progress: attr('number'),
  notes: attr('string'),
  private: attr('boolean'),
  rating: attr('number'),
  reconsumeCount: attr('number'),
  status: attr('string'),
  updatedAt: attr('date'),

  media: belongsTo('media'),
  user: belongsTo('user')
});
