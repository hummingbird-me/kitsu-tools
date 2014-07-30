this.HB = {
  utils: {
    negateString: function(str) {
      str = _.map(str.toLowerCase().split(""), function(l) {
        return String.fromCharCode(-(l.charCodeAt(0)));
      });
      return str;
    }
  },
  statusBar: {
    text: function(text) {
      return $(".status-bar").find("span").text(text);
    },
    action: function(label, callback) {
      return $(".status-bar").find("a").text(label + ".").click(function() {
        callback();
        clearTimeout(HB.statusBar.internal.hideTimeout);
        return HB.statusBar.hide();
      });
    },
    show: function() {
      if (HB.statusBar.internal.visible) {
        clearTimeout(HB.statusBar.internal.hideTimeout);
        HB.statusBar.hide();
      }
      $(".status-bar").slideDown();
      HB.statusBar.internal.visible = true;
      return HB.statusBar.internal.hideTimeout = setTimeout(HB.statusBar.hide, 5000);
    },
    hide: function() {
      $(".status-bar").slideUp();
      return HB.statusBar.internal.visible = false;
    },
    internal: {
      visible: false,
      hideTimeout: null
    }
  }
};
