import Ember from 'ember';

export default function loadScript(scriptUrl) {
  var firstScriptTag = document.getElementsByTagName("script")[0],
      s = document.createElement("script"),
      resolved = false;

  return new Ember.RSVP.Promise(function(resolve, reject) {
    s.type = "text/javascript";
    s.src = scriptUrl;
    s.async = true;
    s.onload = s.onreadstatechange = function() {
      if (!resolved && (!this.readyState || this.readyState === "complete")) {
        resolved = true;
        resolve();
      }
    };
    s.onerror = s.onabord = reject;
    firstScriptTag.parentNode.insertBefore(s, firstScriptTag);
  });
}
