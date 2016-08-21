import MediaIndexRoute from 'client/routes/media/index/route';

export default MediaIndexRoute.extend({
  mediaType: 'drama',
  queryParams: {
    episodeCount: { replace: true }
  }
});
