import Ember from 'ember';
import ModalMixin from '../../mixins/modals/controller';
import VersionableMixin from '../../mixins/modals/versionable';

export default Ember.ObjectController.extend(ModalMixin, VersionableMixin, {
});
