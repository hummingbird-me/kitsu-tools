# Place all the behaviors and hooks related to the matching controller here.
#
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("input.typeahead").typeahead({
    name: 'anime',
    remote: "/search.json?query=%QUERY"
  });
  $("input.typeahead_home").typeahead({
    name: 'anime',
    remote: "/search.json?query=%QUERY"
  });

  $("input.typeahead").on "typeahead:selected", (event) ->
    $("input.typeahead").closest('form').submit();
  $("input.typeahead_home").on "typeahead:selected", (event) ->
    $("input.typeahead_home").parent().parent().submit();

