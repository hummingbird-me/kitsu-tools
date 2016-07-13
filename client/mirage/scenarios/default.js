export default function(server) {
  // Seed database
  server.create('user', { name: 'developer', password: 'password' })
  server.createList('anime', 40);
  server.createList('genre', 10);
  server.createList('streamer', 3);
}
