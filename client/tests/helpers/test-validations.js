import run from 'ember-runloop';

export default function testValidations(context, valid, invalid, assert) {
  Object.keys(valid).forEach((property) => {
    valid[property].forEach((value) => {
      run(context, 'set', property, value);
      assert.ok(context.get(`validations.attrs.${property}.isValid`));
    });
  });

  Object.keys(invalid).forEach((property) => {
    invalid[property].forEach((value) => {
      run(context, 'set', property, value);
      assert.ok(context.get(`validations.attrs.${property}.isInvalid`));
    });
  });
}
