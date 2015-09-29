import { moduleFor, test } from 'ember-qunit';
import InternalSession from 'ember-simple-auth/internal-session';
import EphemeralStore from 'ember-simple-auth/stores/ephemeral';

moduleFor('route:application', 'Unit | Route | application', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  beforeEach() {
    this.session = InternalSession.create({ store: EphemeralStore.create() });
  }
});

test('it exists', function(assert) {
  let route = this.subject({ session: this.session });
  assert.ok(route);
});

test('title works', function(assert) {
  assert.expect(2);
  let route = this.subject({ session: this.session });
  assert.equal(route.title(['One', 'Two']), 'Two | One | Hummingbird');
  assert.equal(route.title(), 'Hummingbird');
});
