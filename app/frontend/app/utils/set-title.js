import Ember from "ember";

export default function setTitle(title) {
  var actualTitle = 'Hummingbird';

  if (typeof title === 'string' && title.length > 0) {
    actualTitle = title + " | Hummingbird";
  }

  document.title = actualTitle;
  Ember.$("meta[name='og:title']").attr('content', title);

  return true;
}
