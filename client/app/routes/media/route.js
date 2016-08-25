import Route from 'ember-route';
import DataErrorMixin from 'client/mixins/routes/data-error';

export default Route.extend(DataErrorMixin, {
  templateName: 'media'
});
