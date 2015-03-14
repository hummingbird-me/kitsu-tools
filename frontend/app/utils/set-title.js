import Ember from "ember";

export default function setTitle(title) {
  var actualTitle = 'Hummingbird';

  if (typeof title === 'string' && title.length > 0) {
    if (title.indexOf('Hummingbird') < 0) {
      actualTitle = title + " | Hummingbird";
    } else {
      actualTitle = title;
    }
  }

  document.title = actualTitle;
  Ember.$("meta[name='og:title']").attr('content', actualTitle);

  return true;
}
