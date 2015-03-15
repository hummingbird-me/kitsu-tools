import escapeHtml from 'frontend/utils/escape-html';

module('escapeHtml');

test('escapes HTML', function() {
  expect(1);
  
  equal(escapeHtml('<p>Test!&"/</p>'), '&lt;p&gt;Test!&amp;&quot;&#x2F;&lt;&#x2F;p&gt;');
});
