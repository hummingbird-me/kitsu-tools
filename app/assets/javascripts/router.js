Hummingbird.Router.reopen({
  location: 'history'
});

Hummingbird.Router.map(function() {
  this.resource('anime', {path: '/anime/:id'}, function() {
    this.resource('reviews', {path: '/reviews'}, function() {
      this.route('show', {path: '/:review_id'});
    });
  });

  this.resource('manga', {path: '/manga/:id'}, function() {
    this.route('reviews');
  });

  this.resource('user', {path: '/users/:id'}, function() {
    this.route('library');
    this.route('reviews');
    this.route('following');
    this.route('followers');
  });
  
  this.route('sign-in');
  this.route('dashboard');
  this.route('development');
  this.route('notifications');
});