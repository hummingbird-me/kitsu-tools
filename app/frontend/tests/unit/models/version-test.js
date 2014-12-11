import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('version', 'Version', {
  // Specify the other units that are required for this test.
  needs: ['model:user', 'model:full-anime', 'model:full-manga', 'model:episode',
          'model:producer', 'model:franchise', 'model:quote', 'model:review',
          'model:casting', 'model:library-entry', 'model:manga-library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
