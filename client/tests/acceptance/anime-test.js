import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import testSelector from 'client/tests/helpers/ember-test-selectors';

moduleForAcceptance('Acceptance | Anime');

test('I should see a list of anime with filtering options', function(assert) {
  assert.expect(3);
  server.createList('anime', 20);
  server.createList('genre', 10);
  server.createList('streamer', 5);

  visit('/anime');

  andThen(() => {
    const media = find(testSelector('selector', 'media-poster'));
    const genres = find(testSelector('selector', 'filter-genre'));
    const streamers = find(testSelector('selector', 'filter-streamer'));

    assert.equal(media.length, 20);
    assert.equal(genres.length, 10);
    assert.equal(streamers.length, 5);
  });
});

test('I should be able to view an anime page', function(assert) {
  assert.expect(1);
  const anime = server.create('anime', { canonicalTitle: 'Hello World' });
  visit(`/anime/${anime.slug}`);

  andThen(() => {
    const title = find(testSelector('selector', 'title'));
    assert.equal(title.text().trim(), 'Hello World');
  });
});
