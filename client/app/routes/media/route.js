import Route from 'ember-route';
import DataRouteErrorMixin from 'client/mixins/routes/data-route-error';

export default Route.extend(DataRouteErrorMixin, {
  templateName: 'media'
});
