function mockRoutes(server) {
  // Routes outside our namespace
  server.post('/api/oauth/token', () => {});

  // Routes after this point will be namespaced with the following
  server.namespace = 'api/edge';

  // Media routes
  server.get('/anime');
  server.get('/anime/:id');

  server.get('/genres');
  server.get('/streamers');

  // User routes
  server.post('/users');
  server.get('/users');
  server.get('/users/:id');
}

// Development
export default function() {
  // mockRoutes(this);
  this.passthrough();
}

// Tests
export function testConfig() {
  // Coverage route
  this.passthrough('/write-coverage');
  mockRoutes(this);
}
