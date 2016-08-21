import MediaIndexController from 'client/routes/media/index/controller';

export default MediaIndexController.extend({
  queryParams: ['episodeCount'],
  episodeCount: [1, 1000]
});
