import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('full-manga', 'FullManga', {
  // Specify the other units that are required for this test.
  needs: ['model:casting', 'model:character', 'model:person', 'model:manga',
          'model:manga-library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
