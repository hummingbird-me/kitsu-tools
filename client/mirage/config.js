function mockRoutes(server) {
  // Routes outside our namespace
  server.post('/api/oauth/token', () => {});

  // Routes after this point will be namespaced with the following
  server.namespace = 'api/edge';

  server.get('/anime');
  server.get('/anime/:id');

  server.get('/genres');
  server.get('/streamers');

  server.get('/library-entries');
  server.post('/library-entries');
  server.patch('/library-entries');
  server.del('/library-entries/:id');

  server.get('/users');
  server.get('/users/:id');
  server.post('/users');
}

// Development
export default function() {
  // Enable the next line if you want to mock the rails API server
  // mockRoutes(this);
  this.passthrough();
}

// Tests
export function testConfig() {
  this.passthrough('/write-coverage');
  mockRoutes(this);
}
