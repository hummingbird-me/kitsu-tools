import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('manga', 'Manga', {
  // Specify the other units that are required for this test.
  needs: ['model:manga-library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
