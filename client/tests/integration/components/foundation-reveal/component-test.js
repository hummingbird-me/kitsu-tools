import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import jQuery from 'jquery';

moduleForComponent('foundation-reveal', 'Integration | Component | foundation reveal', {
  integration: true,

  afterEach() {
    // reveal renders outside the outlet so clean it up
    jQuery('[data-reveal]').remove();
  }
});

test('it renders', function(assert) {
  this.render(hbs`
    {{#foundation-reveal modalId="hello" modalClass="world"}}
      <span data-test-selector="span">Hello, World!</span>
    {{/foundation-reveal}}
  `);

  // id/class set
  assert.equal(jQuery('[data-reveal]').attr('id'), 'hello');
  assert.ok(jQuery('[data-reveal]').hasClass('world'));

  // block is rendered
  const $text = jQuery('[data-test-selector="span"]');
  assert.equal($text.text().trim(), 'Hello, World!');

  // button is created
  const $button = jQuery('button.close-button');
  assert.equal($button.text().trim(), '×');
});
