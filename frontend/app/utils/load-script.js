import Ember from 'ember';

export default function loadScript(scriptUrl, options) {
  var firstScriptTag = document.getElementsByTagName("script")[0],
      s = document.createElement("script"),
      resolved = false;

  return new Ember.RSVP.Promise(function(resolve, reject) {
    s.type = "text/javascript";
    s.src = scriptUrl;
    s.async = true;
    if (options) {
      Object.keys(options).forEach(function(key) {
        s.setAttribute(key, options[key]);
      });
    }
    s.onload = s.onreadstatechange = function() {
      if (!resolved && (!this.readyState || this.readyState === "complete")) {
        resolved = true;
        resolve();
      }
    };
    s.onerror = s.onabort = reject;
    firstScriptTag.parentNode.insertBefore(s, firstScriptTag);
  });
}
