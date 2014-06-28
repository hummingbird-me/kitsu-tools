Hummingbird.computed = {
  propertyEqual: function(p1, p2) {
    return Em.computed(function() {
      return this.get(p1) === this.get(p2);
    }).property(p1, p2);
  }
};
