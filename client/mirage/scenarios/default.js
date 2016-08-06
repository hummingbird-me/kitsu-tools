/**
 * These models are created from mirage under the development environment
 */
export default function(server) {
  server.createList('genre', 10);
  server.createList('streamer', 5);
  const user = server.create('user', { name: 'developer', password: 'password' });
  const media = server.createList('anime', 100);
  const entries = server.createList('library-entry', 40, { user });
  entries.forEach((entry, idx) => {
    entry.media = media[idx];
    entry.save();
  });
}
