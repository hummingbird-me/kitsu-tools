import { moduleForModel, test } from 'ember-qunit';
import set from 'ember-metal/set';
import get from 'ember-metal/get';
import run from 'ember-runloop';

moduleForModel('anime', 'Unit | Model | anime', {
  needs: ['model:genre']
});

test('typeStr', function(assert) {
  assert.expect(6);
  const anime = this.subject();

  // 1 - TV, 2 - Special, 3 - ONA, 4 - OVA, 5 - Movie, 6 - Music
  const data = ['TV', 'Special', 'ONA', 'OVA', 'Movie', 'Music'];
  run(() => {
    for (let i = 0; i < data.length; ++i) {
      set(anime, 'showType', i + 1);
      assert.equal(get(anime, 'typeStr'), data[i]);
    }
  });
});
