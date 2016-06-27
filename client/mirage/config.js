// Development
export default function() {
  this.passthrough();
}

// Tests
export function testConfig() {
  // Coverage route
  this.passthrough('/write-coverage');

  // Routes outside our namespace
  this.post('/api/oauth/token', () => {});

  // Routes after this point will be namespaced with the following
  this.namespace = 'api/edge';

  // Media routes
  this.get('/anime');
  this.get('/anime/:id');

  this.get('/genres');
  this.get('/streamers');

  // User routes
  this.post('/users');
  this.get('/users');
  this.get('/users/:id');
}
