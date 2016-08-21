import MediaIndexController from 'client/routes/media/index/controller';

export default MediaIndexController.extend({
  queryParams: ['ageRating', 'episodeCount', 'streamers'],
  ageRating: [],
  episodeCount: [1, 1000],
  streamers: [],

  availableAgeRatings: ['G', 'PG', 'R', 'R18'],
  availableStreamers: []
});
