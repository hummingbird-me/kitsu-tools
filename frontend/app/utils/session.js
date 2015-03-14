import ajax from 'ic-ajax';

export default {
  signIn: function(email, password) {
    return ajax({
      url: "/sign-in",
      type: "POST",
      data: {
        email: email,
        password: password
      }
    });
  },

  signOut: function() {
    return ajax({
      url: "/sign-out",
      type: "POST"
    }).then(function() {
      window.location.href = window.location.href;
    });
  }
};
