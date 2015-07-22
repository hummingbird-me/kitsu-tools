export function initialize(registry) {
  ['route', 'view', 'component', 'controller'].forEach((component) => {
    registry.injection(component, 'currentUser', 'service:current-user');
  });
}

export default {
  name: 'current-user',
  initialize: initialize
};
