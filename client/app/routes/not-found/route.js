import Route from 'ember-route';

export default Route.extend({
  // This results in redirecting to `/404` if that isn't the current URL.
  redirect() {
    const notFoundURL = this.router.location.formatURL('/404');
    if (window.location.pathname !== notFoundURL) {
      this.transitionTo('/404');
    }
  }
});
