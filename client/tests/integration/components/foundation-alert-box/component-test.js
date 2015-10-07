import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-alert-box', 'Integration | Component | foundation alert box', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);
  this.render(hbs`{{foundation-alert-box type="success" closable=true}}`);

  // type is set
  const $alert = this.$('.alert-box.success');
  assert.equal($alert.length, 1);

  // button is created
  const $button = this.$('.alert-box button');
  assert.equal($button.length, 1);
  assert.equal($button.text().trim(), '×');
});

test('block renders', function(assert) {
  assert.expect(1);
  this.render(hbs`
    {{#foundation-alert-box type="success" closable=false}}
      Hello, World!
    {{/foundation-alert-box}}
  `);

  // text is displayed
  const $alert = this.$('.alert-box.success');
  assert.equal($alert.text().trim(), 'Hello, World!');
});
