HB.ModalsReportController = Ember.ObjectController.extend(HB.HasCurrentUser, HB.ModalControllerMixin, {

  reportReason: "",

  reportItem: function(){
    var type = this.get('content.constructor.typeKey');
    return type + ":" + this.get('content.id');
  }.property('content'),


  actions: {
    sendReport: function(){

      // Create report record and push it to the server
      // current user: currentUser.username

      alert("Not implemented yet!");
    }
  }

});
