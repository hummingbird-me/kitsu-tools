import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import $ from 'jquery';

moduleForComponent('foundation-reveal', 'Integration | Component | foundation reveal', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(4);
  this.render(hbs`
    {{#foundation-reveal modalId="hello" modalClass="world"}}
      <span data-test-selector="span">Hello, World!</span>
    {{/foundation-reveal}}
  `);

  // id/class set
  assert.equal($('[data-reveal]').attr('id'), 'hello');
  assert.ok($('[data-reveal]').hasClass('world'));

  // block is rendered
  const $text = $('[data-test-selector="span"]');
  assert.equal($text.text().trim(), 'Hello, World!');

  // button is created
  const $button = $('button.close-button');
  assert.equal($button.text().trim(), '×');
});
