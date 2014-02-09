Hummingbird.Session =
  getAuthToken: ->
    parts = document.cookie.split("auth_token=")
    if parts.length == 2
      parts.pop().split(';').shift()

  signInWithOptionalRedirect: (email, password, redirect) ->
    $.ajax "/api/v2/sign-in",
      type: "POST"
      data:
        email: email
        password: password
      success: (data) ->
        # Set cookie.
        cookieString = "auth_token=" + data["auth_token"]
        unless window.location.host == "localhost:3000"
          cookieString += ";domain=." + window.location.host
        cookieString += ";max-age=" + 60*60*60*24*365
        cookieString += ";path=/"
        document.cookie = cookieString
        # Redirect to previous URL.
        if redirect
          window.location.href = window.lastVisitedURL
      error: (jqXHR, textStatus, errorThrown) ->
        # TODO handle error.
        alert(errorThrown)

  signIn: (email, password) -> Hummingbird.Session.signInWithOptionalRedirect(email, password, true)
  signInWithoutRedirect: (email, password) -> Hummingbird.Session.signInWithOptionalRedirect(email, password, false)

  signOut: ->
    ic.ajax
      url: "/sign-out"
      type: "POST"
    .then ->
      window.location.href = window.location.href

