import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('full-anime', 'FullAnime', {
  // Specify the other units that are required for this test.
  needs: ['model:episode', 'model:casting', 'model:person', 'model:character',
          'model:producer', 'model:franchise', 'model:quote', 'model:review',
          'model:anime', 'model:video', 'model:user', 'model:library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
