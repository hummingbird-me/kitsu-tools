Hummingbird.LibraryEntryView = Ember.View.extend
  templateName: "library/entry"
  showDropdown: false

  entryRatingHTML: (->
    rating = @get('content.rating')
    if @get('controller.user.ratingType') == "advanced"
      if rating
        new Handlebars.SafeString ("<i class='fa fa-star'></i> " + rating.toFixed(1))
      else
        new Handlebars.SafeString "<i class='fa fa-star'></i> <span>----</span>"
    else
      if rating
        if @get('content.positiveRating')
          new Handlebars.SafeString "<i class='fa fa-smile-o'></i>"
        else if @get('content.negativeRating')
          new Handlebars.SafeString "<i class='fa fa-frown-o'></i>"
        else
          new Handlebars.SafeString "<i class='fa fa-meh-o'></i>"
      else
        new Handlebars.SafeString "<span>---</span>"
  ).property('content.rating')

  click: (event) ->
    unless event.target.nodeName == "INPUT"
      if $(event.target).closest('.list-group-item').length == 1
        that = this
        if @get('showDropdown')
          @$('.library-dropdown').slideUp 200, ->
            that.set 'showDropdown', false
        else
          @$('.library-dropdown').slideDown 200, ->
            that.set 'showDropdown', true
