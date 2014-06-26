Hummingbird.Session = {
  getAuthToken: function() {
    var parts = document.cookie.split("auth_token=");
    if (parts.length === 2) {
      return parts.pop().split(';').shift();
    }
  },
  signInWithOptionalRedirect: function(email, password, redirect) {
    return $.ajax("/api/v2/sign-in", {
      type: "POST",
      data: {
        email: email,
        password: password
      },
      success: function(data) {
        // Set cookie.
        var cookieString = "auth_token=" + data["auth_token"];
        if (window.location.host !== "localhost:3000") {
          cookieString += ";domain=." + window.location.host;
        }
        cookieString += ";max-age=" + 60 * 60 * 60 * 24 * 365;
        cookieString += ";path=/";
        document.cookie = cookieString;
        // Redirect to previous URL.
        if (redirect) {
          window.location.href = window.lastVisitedURL;
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // TODO handle error.
        return alert(errorThrown);
      }
    });
  },
  signIn: function(email, password) {
    return Hummingbird.Session.signInWithOptionalRedirect(email, password, true);
  },
  signInWithoutRedirect: function(email, password) {
    return Hummingbird.Session.signInWithOptionalRedirect(email, password, false);
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
