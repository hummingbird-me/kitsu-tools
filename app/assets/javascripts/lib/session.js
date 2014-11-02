HB.Session = {
  signIn: function(email, password) {
    return ic.ajax({
      url: "/sign-in",
      type: "POST",
      data: {
        email: email,
        password: password
      }
    });
  },
  signOut: function() {
    return ic.ajax({
      url: "/sign-out",
      type: "POST"
    }).then(function() {
      window.location.href = window.location.href;
    });
  }
};
