# Place all the behaviors and hooks related to the matching controller here.
#
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("input.typeahead").typeahead
    name: 'anime'
    template: HandlebarsTemplates["search/typeahead"]
    remote: 
      url: "/api/v1/search/anime?query=%QUERY"
      filter: (parsedResponse) ->
        _.map parsedResponse, (anime) ->
          value = anime.title
          tokens = anime.title.split(' ')
          if anime.alternate_title
            tokens = _.union tokens, anime.alternate_title.split(' ')
          value: value
          tokens: tokens
          image: anime.cover_image
          url: anime.url

  #  $("input.typeahead").on "typeahead:selected", (event) ->
  #  $("input.typeahead").closest('form').submit();
