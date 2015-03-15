import PreloadStore from './preload-store';
import ajax from 'ic-ajax';
/* global $ */

function getTwemoji(unicode) {
  let url = `https://twemoji.maxcdn.com/36x36/${unicode}.png`;
  return `<img class="emoji" src="${url}">`;
}

export default function suggester(context) {
  context.textcomplete([
    { // emoji
      emojis: PreloadStore.get("emoji"),
      match: /(^|\s):(\w*)$/,
      search: function(term, callback) {
        let emojis = Object.keys(this.emojis).map((e) => e.substr(1, e.length - 2));
        let regexp = new RegExp('^' + term);
        callback($.grep(emojis, (emoji) => regexp.test(emoji)));
      },
      template: function(value) {
        let preview = getTwemoji(this.emojis[`:${value}:`]);
        return `${preview}  ${value}`;
      },
      replace: function(value) {
        return `$1:${value}: `;
      }
    },
    { // mentions
      cache: true,
      debounce: 500,
      match: /(^|\s)@(\w*)$/,
      search: function(term, callback) {
        // show some staff when user enters just '@'
        let names = ['Josh', 'Nuck', 'ryn', 'cybrox', 'vevix'];
        if (!term) {
          return callback(names);
        }
        // actually search for the query!
        ajax({
          url: `/search?scope=users&depth=instant&query=${term}`,
          dataType: 'json'
        }).then((data) => {
          let names = data['search'].map((e) => e['title']);
          callback(names);
        }, () => { callback([]); });
      },
      template: function(value) {
        return `<b>${value}</b>`;
      },
      replace: function(value) {
        return `$1@${value} `;
      }
    }
  ], { maxCount: 5 });
}
