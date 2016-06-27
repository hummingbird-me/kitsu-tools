import { moduleForModel, test } from 'ember-qunit';
import run from 'ember-runloop';
import set from 'ember-metal/set';
import get from 'ember-metal/get';

moduleForModel('media', 'Unit | Model | media', {
  needs: ['model:genre']
});

test('mergedTitles works', function(assert) {
  const media = this.subject();
  run(() => {
    set(media, 'titles', {
      one: 'Hello',
      two: ', ',
      three: 'World',
      four: '!'
    });
  });
  assert.equal(get(media, 'mergedTitles'), 'hello, world!');
});
