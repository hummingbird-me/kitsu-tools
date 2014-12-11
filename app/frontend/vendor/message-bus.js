/*jshint bitwise: false*/

/**
  Message Bus functionality.

  @class MessageBus
  @namespace Discourse
  @module Discourse
**/
window.MessageBus = (function() {
  // http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript
  var callbacks, clientId, failCount, shouldLongPoll, queue, responseCallbacks, uniqueId, baseUrl;
  var me, started, stopped, longPoller, pollTimeout;

  uniqueId = function() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r, v;
      r = Math.random() * 16 | 0;
      v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  };

  clientId = uniqueId();
  responseCallbacks = {};
  callbacks = [];
  queue = [];
  interval = null;
  failCount = 0;
  baseUrl = "/";

  /* TODO: The plan is to force a long poll as soon as page becomes visible
  // MIT based off https://github.com/mathiasbynens/jquery-visibility/blob/master/jquery-visibility.js
  initVisibilityTracking =  function(window, document, $, undefined) {
    var prefix;
    var property;
    // In Opera, `'onfocusin' in document == true`, hence the extra `hasFocus` check to detect IE-like behavior
    var eventName = 'onfocusin' in document && 'hasFocus' in document ? 'focusin focusout' : 'focus blur';
    var prefixes = ['webkit', 'o', 'ms', 'moz', ''];
    var $event = $.event;

    while ((prefix = prefixes.pop()) !== undefined) {
      property = (prefix ? prefix + 'H': 'h') + 'idden';
      var supportsVisibility = typeof document[property] === 'boolean';
      if (supportsVisibility) {
        eventName = prefix + 'visibilitychange';
        break;
      }
    }

    $(/blur$/.test(eventName) ? window : document).on(eventName, function(event) {
      var type = event.type;
      var originalEvent = event.originalEvent;

      // Avoid errors from triggered native events for which `originalEvent` is
      // not available.
      if (!originalEvent) {
              return;
      }

      var toElement = originalEvent.toElement;

      // If it's a `{focusin,focusout}` event (IE), `fromElement` and `toElement`
      // should both be `null` or `undefined`; else, the page visibility hasn't
      // changed, but the user just clicked somewhere in the doc. In IE9, we need
      // to check the `relatedTarget` property instead.
      if (
              !/^focus./.test(type) || (
                      toElement === undefined &&
                      originalEvent.fromElement === undefined &&
                      originalEvent.relatedTarget === undefined
              )
      ) {
          visibilityChanged(property && document[property] || /^(?:blur|focusout)$/.test(type) ? 'hide' : 'show');
      }
    });

  };
  */

  var hiddenProperty;

  $.each(["","webkit","ms","moz","ms"], function(index, prefix){
    var check = prefix + (prefix === "" ? "hidden" : "Hidden");
    if(document[check] !== undefined ){
      hiddenProperty = check;
    }
  });

  var isHidden = function() {
    if (hiddenProperty !== undefined){
      return document[hiddenProperty];
    } else {
      return !document.hasFocus;
    }
  };

  shouldLongPoll = function() {
    return me.alwaysLongPoll || !isHidden();
  };

  var totalAjaxFailures = 0;
  var totalAjaxCalls = 0;
  var lastAjax;

  longPoller = function(poll,data){
    var gotData = false;
    var aborted = false;
    lastAjax = new Date();
    totalAjaxCalls += 1;

    return $.ajax(me.baseUrl + "message-bus/" + me.clientId + "/poll?" + (!shouldLongPoll() || !me.enableLongPolling ? "dlp=t" : ""), {
      data: data,
      cache: false,
      dataType: 'json',
      type: 'POST',
      headers: {
        'X-SILENCE-LOGGER': 'true'
      },
      success: function(messages) {
        failCount = 0;
        if (messages === null) return; // server unexpectedly closed connection
        $.each(messages,function(_,message) {
          gotData = true;
          $.each(callbacks, function(_,callback) {
            if (callback.channel === message.channel) {
              callback.last_id = message.message_id;
              try {
                callback.func(message.data);
              }
              catch(e){
                if(console.log) {
                  console.log("MESSAGE BUS FAIL: callback " + callback.channel +  " caused exception " + e.message);
                }
              }
            }
            if (message.channel === "/__status") {
              if (message.data[callback.channel] !== undefined) {
                callback.last_id = message.data[callback.channel];
              }
            }
          });
        });
      },
      error: function(xhr, textStatus, err) {
        if(textStatus === "abort") {
          aborted = true;
        } else {
          failCount += 1;
          totalAjaxFailures += 1;
        }
      },
      complete: function() {
        var interval;
        try {
          if (gotData || aborted) {
            interval = 100;
          } else {
            interval = me.callbackInterval;
            if (failCount > 2) {
              interval = interval * failCount;
            } else if (!shouldLongPoll()) {
              // slowing down stuff a lot when hidden
              // we will need to fine tune this
              interval = interval * 4;
            }
            if (interval > me.maxPollInterval) {
              interval = me.maxPollInterval;
            }

            interval -= (new Date() - lastAjax);

            if (interval < 100) {
              interval = 100;
            }
          }
        } catch(e) {
          if(console.log && e.message) {
            console.log("MESSAGE BUS FAIL: " + e.message);
          }
        }

        pollTimeout = setTimeout(poll, interval);
        me.longPoll = null;
      }
    });
  };

  me = {
    enableLongPolling: true,
    callbackInterval: 15000,
    maxPollInterval: 3 * 60 * 1000,
    callbacks: callbacks,
    clientId: clientId,
    alwaysLongPoll: false,
    baseUrl: baseUrl,

    diagnostics: function(){
      console.log("Stopped: " + stopped + " Started: " + started);
      console.log("Current callbacks");
      console.log(callbacks);
      console.log("Total ajax calls: " + totalAjaxCalls + " Recent failure count: " + failCount + " Total failures: " + totalAjaxFailures);
      console.log("Last ajax call: " + (new Date() - lastAjax) / 1000  + " seconds ago") ;
    },

    stop: function() {
      stopped = true;
      started = false;
    },

    // Start polling
    start: function(opts) {
      var poll;

      if (started) return;
      started = true;
      stopped = false;

      if (!opts) opts = {};

      poll = function() {
        var data;

        if(stopped) {
          return;
        }

        if (callbacks.length === 0) {
          setTimeout(poll, 500);
          return;
        }

        data = {};
        $.each(callbacks, function(_,callback) {
          data[callback.channel] = callback.last_id;
        });
        me.longPoll = longPoller(poll,data);
      };
      poll();
    },

    // Subscribe to a channel
    subscribe: function(channel, func, lastId) {

      if(!started && !stopped){
        me.start();
      }

      if (typeof(lastId) !== "number" || lastId < -1){
        lastId = -1;
      }
      callbacks.push({
        channel: channel,
        func: func,
        last_id: lastId
      });
      if (me.longPoll) {
        return me.longPoll.abort();
      }
    },

    // Unsubscribe from a channel
    unsubscribe: function(channel) {
      // TODO proper globbing
      var glob;
      if (channel.indexOf("*", channel.length - 1) !== -1) {
        channel = channel.substr(0, channel.length - 1);
        glob = true;
      }
      callbacks = $.grep(callbacks,function(callback) {
        if (glob) {
          return callback.channel.substr(0, channel.length) !== channel;
        } else {
          return callback.channel !== channel;
        }
      });
      if (me.longPoll) {
        return me.longPoll.abort();
      }
    }
  };

  return me;
})();
