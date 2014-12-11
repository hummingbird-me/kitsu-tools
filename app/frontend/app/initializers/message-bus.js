/* global MessageBus */

export function initialize() {
  MessageBus.start();
}

export default {
  name: 'message-bus',
  initialize: initialize
};
