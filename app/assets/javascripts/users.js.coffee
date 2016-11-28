# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


initClickAuthApplicationButton = ->
  $('.auth-application-button').click ->
    $('#authModal').modal("show")

generateToken = ->
  $('.generate-token-button').click ->
    shaObj = new jsSHA("SHA-1", "TEXT")
    id = $('.id-form').val()
    user = getUser(id)
    shaObj.update(Math.random().toString() + user.created_at + user.updated_at)
    hash = shaObj.getHash("HEX")
    $('.token-field').val(hash)

ready = ->
  initClickAuthApplicationButton()
  generateToken()

$(document).ready(ready)
$(document).on('page:load', ready)

getUser = (id) ->
 res = $ . ajax
   type: 'GET'
   url: "/users/#{id}.json"
   dataType: "json"
   async: false
   error: ->
     alert("error")
 res.responseJSON
