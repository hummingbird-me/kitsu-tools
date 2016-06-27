import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | anime');

test('visting `anime.index`', function(assert) {
  assert.expect(3);
  server.createList('anime', 20);
  server.createList('genre', 10);
  server.createList('streamer', 5);
  visit('/anime');

  andThen(() => {
    const media = find('[data-test-selector="media-poster-summary"]');
    assert.equal(media.length, 20);
    const genres = find('[data-test-selector="filter-genre"]');
    assert.equal(genres.length, 10);
    const streamers = find('[data-test-selector="filter-streamer"]');
    assert.equal(streamers.length, 5);
  });
});

test('visiting `anime.show`', function(assert) {
  assert.expect(2);
  const anime = server.create('anime', { canonicalTitle: 'Hello World' });
  visit(`/anime/${anime.slug}`);
  andThen(() => {
    const title = find('[data-test-selector="title"]');
    assert.equal(title.length, 1);
    assert.ok(title.text().includes('Hello World'));
  });
});

test('visiting `anime.show` can redirect to 404', function(assert) {
  assert.expect(1);
  server.get('/anime', {}, 404);
  visit('/anime/doesnt-exist');
  andThen(() => assert.equal(currentURL(), '/404'));
});

test('visiting `anime.show` with an id redirects to the slugged route', function(assert) {
  assert.expect(1);
  const anime = server.create('anime', { slug: 'test-slug' });
  visit(`/anime/${anime.id}`);
  andThen(() => assert.equal(currentURL(), '/anime/test-slug'));
});
