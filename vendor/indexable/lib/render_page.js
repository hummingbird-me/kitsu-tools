// TODO Add header.
//
// Based off https://gist.github.com/pieterjongsma/4515412

var fs      = require('fs');
var system  = require('system');
var page    = require('webpage').create();
var path    = system.args[1];
var url     = system.args[2];
var content = fs.read(path);

// Keep track of whether the page has already been exported, because the '
// 'setTimeout's we use might cause it to be exported multiple times.
var pageHasBeenExported = false;
function exportPage(content) {
  if (!pageHasBeenExported) {
    pageHasBeenExported = true;
    console.log(content);
    phantom.exit();
  }
}

// Since Ember has no method that indicates when everything has loaded, we keep
// keep track of resource requests. The claim is that the page is ready when there
// are no outstanding requests for resources.
//
// This is not strictly true, because sometimes a resource still needs to be
// rendered after loading, or the application might still be building a request.
// To work around this, we wait an addition 2 seconds to make sure rendering etc.
// can take place.
//
// We need to keep track of request/response IDs, not just the count because larger
// resources may be returned in chunks.

var activeRequests = [];

page.onResourceRequested = function(requestData, networkRequest) {
  if ((/ga\.js/gi).test(requestData.url) || (/dc\.js/gi).test(requestData.url)) {
    // Don't load ga.js and dc.js to avoid polluting Google Analytics data
    // regardless of whether external resources are allowed or not.
    networkRequest.abort();
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
      if (activeRequests.length == 0) {
        exportPage(page.content);
      }
    }, 2000);
  }
}

page.setContent(content, url);

