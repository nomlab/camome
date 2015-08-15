initDraggableClam = ->
  $('.draggable-clam').draggable
    helper: (event) ->
      length =  $(".selected").length

      # length = 1 if no check
      length = 1 if length is 0
      $("<span style='white-space:nowrap;'>").text length + "mails"
    revert: "invalid"

displayCalendar = ->
  if ($('.mini-calendar').is(':visible') == true)
    $('.mini-calendar').hide(100, ->
      $('.clams-table').css('width','100%')
    )
  else
    $('.mini-calendar').show(100)
    $('.clams-table').css('width','55%')
    $('.clams-table').css('float','right')

ready = ->
  initDraggableClam()
  $('.mini-calendar').hide()
  $(".calendar-icon").click ->
    displayCalendar()

$(document).ready(ready)
$(document).on('page:load', ready)
