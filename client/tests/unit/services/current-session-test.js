import { moduleFor, test } from 'ember-qunit';
import run from 'ember-runloop';
import set from 'ember-metal/set';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import setupStore from 'client/tests/helpers/setup-store';

moduleFor('service:current-session', 'Unit | Service | current session', {
  beforeEach() {
    this.store = setupStore({
      user: Model.extend({
        name: attr('string')
      })
    });
  },

  afterEach() {
    run(this.store, 'destroy');
  }
});

test('#account returns current user', function(assert) {
  const service = this.subject({ store: this.store, userId: 1 });
  run(() => {
    this.user = this.store.push({
      data: {
        type: 'user',
        id: '1',
        attributes: {
          name: 'Holo'
        }
      }
    });
  });
  assert.equal(service.get('account'), this.user);

  // #account returns undefined if `userId` is unset.
  run(() => set(service, 'userId', undefined));
  assert.equal(service.get('account'), undefined);
});

test('#clean sets `userId` to undefined', function(assert) {
  const service = this.subject({ userId: 1 });
  service.clean();
  assert.equal(service.get('userId'), undefined);
});

test('#invalidate calls #invalidate on the session', function(assert) {
  assert.expect(1);
  const service = this.subject({
    session: {
      invalidate() {
        assert.ok(true);
      }
    }
  });
  service.invalidate();
});

test('#isCurrentUser tests if the passed user is the current user', function(assert) {
  const service = this.subject({
    session: { isAuthenticated: true },
    userId: 1
  });
  let result = service.isCurrentUser({ id: 1 });
  assert.ok(result);
  result = service.isCurrentUser({ id: 2 });
  assert.notOk(result);
});
