var fs      = require('fs');
var system  = require('system');
var page    = require('webpage').create();
var url     = system.args[1];

// Keep track of whether the page has already been exported, because the '
// 'setTimeout's we use might cause it to be exported multiple times.
var pageHasBeenExported = false;
function output(json) {
  if (!pageHasBeenExported) {
    pageHasBeenExported = true;
    console.log(JSON.stringify(json));
    phantom.exit();
  }
}

// Since Ember has no method that indicates when everything has loaded, we keep
// keep track of resource requests. The claim is that the page is ready when there
// are no outstanding requests for resources.
//
// This is not strictly true, because sometimes a resource still needs to be
// rendered after loading, or the application might still be building a request.
// To work around this, we wait an addition 5 seconds to make sure rendering etc.
// can take place.
//
// We need to keep track of request/response IDs, not just the count because larger
// resources may be returned in chunks.

var activeRequests = [];

page.onResourceRequested = function(requestData, request) {
  if ((/ga\.js/gi).test(requestData.url) || (/dc\.js/gi).test(requestData.url)) {
    request.abort();
  }
  else {
    activeRequests.push(requestData.id);
  }
}

page.onResourceReceived = function(response) {
  // Remove the ID from the array.
  activeRequests.splice(activeRequests.indexOf(response.id), 1);

  // Should we output the HTML?
  if (activeRequests.length == 0) {
    window.setTimeout(function() {
      if (activeRequests == 0) {
        output({"status": 200, "content": page.content});
      }
    }, 5000);
  }
}

page.open(url, function(status) {
  if (status != 'success') {
    output({"status": 404, "content": "Page not found"});
    phantom.exit();
  }
  else {
    // If the page isn't finished loading in 10 seconds, something is probably
    // wrong and we're going to just return.
    window.setTimeout(function() {
      output({"status": 500, "content": "Something went wrong"});
      phantom.exit();
    }, 10000);
  }
});
