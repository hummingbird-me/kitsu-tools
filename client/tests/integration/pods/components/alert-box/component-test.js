import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('alert-box', 'Integration | Component | alert box', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(4);

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });
  this.render(hbs`<alert-box type="success" />`);

  // type is set
  let $alert = this.$('.alert-box.success');
  assert.equal($alert.length, 1);
  // button is created
  let $button = this.$('.alert-box button');
  assert.equal($button.length, 1);
  assert.equal($button.text().trim(), '×');

  this.render(hbs`
    <alert-box type="success">
      Hello, World!
    </alert-box>
  `);

  // text is displayed
  $alert = this.$('.alert-box.success p');
  assert.equal($alert.text().trim(), 'Hello, World!');
});
