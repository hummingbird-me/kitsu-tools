import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('alert-box', 'Integration | Component | alert box', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);
  this.render(hbs`<alert-box type="success" closable=true />`);

  // type is set
  let $alert = this.$('.alert-box.success');
  assert.equal($alert.length, 1);

  // button is created
  let $button = this.$('.alert-box button');
  assert.equal($button.length, 1);
  assert.equal($button.text().trim(), '×');
});


test('block renders', function(assert) {
    assert.expect(1);
    this.render(hbs`
      <alert-box type="success" closable=false>
        Hello, World!
      </alert-box>
    `);

    // text is displayed
    let $alert = this.$('.alert-box.success');
    assert.equal($alert.text().trim(), 'Hello, World!');
});
