# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


initClickAuthApplicationButton = ->
  $('.auth-application-button').click ->
    $('#authModal').modal("show")

ready = ->
  initClickAuthApplicationButton()

$(document).ready(ready)
$(document).on('page:load', ready)
