_.extend(HB, {
  header: {
    lastScroll: 0,
    hideShowOffset: 20,
    detachPoint: 500,
    attached: true,
    visible: true,
    open: false,
    el: null,
    detach: function() {
      if (this.attached && !this.visible) {
        this.el.removeClass("nav-attached");
        return this.attached = false;
      }
    },
    attach: function() {
      this.show();
      if (!this.attached) {
        this.el.addClass("nav-attached");
        return this.attached = true;
      }
    },
    show: function() {
      if (!this.visible) {
        this.el.removeClass("nav-hidden").addClass("nav-visible");
        return this.visible = true;
      }
    },
    hide: function() {
      if (this.visible) {
        this.el.removeClass("nav-visible").addClass("nav-hidden");
        return this.visible = false;
      }
    },
    scrollHandler: function() {
      var amount, top;
      top = $(window).scrollTop();
      amount = Math.abs(top - this.lastScroll);
      if (top > this.detachPoint) {
        this.detach();
      }
      if (top <= this.detachPoint) {
        this.attach();
      }
      if (top > -1 && amount > this.hideShowOffset) {
        if (top > this.lastScroll) {
          this.hide();
        } else {
          this.show();
        }
      }
      return this.lastScroll = top;
    },
    init: function() {
      this.el = $(".hummingbird-header-actual");
      return $(window).bind('scroll', _.throttle(_.bind(this.scrollHandler, this), 250));
    }
  }
});

$(function() {
  return HB.header.init();
});
