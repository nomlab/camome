# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fullCalendar = ->
  $('#calendar').fullCalendar
    editable: false
    selectable: true
    droppable: true
    timezone: 'Tokyo'
    timeFormat:
      month: 'HH:mm'
      week: 'HH:mm'
      day: 'HH:mm'
    events: '/events.json'

    drop:
      (date) ->
        $('#createEventFromMail #eventStartTime').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#createEventFromMail #eventEndTime').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#createEventFromMail #eventSummary').val($(this).data('clam').summary)
        $('.mail').append("<a href='#' id='mail' data-id='#{$(this).data('clam').id}'>#{$(this).data('clam').summary}</a>")
        $('#createEventFromMail').modal('show')

initDraggableClam = ->
  $('.draggable-clam').each ->
    clam = {
      id: $(this).attr("data-id")
      summary: $(this).attr("data-summary")
    }
    $(this).data('clam', clam)

    $(this).draggable
      appendTo: "body"
      zIndex: 999
      helper: (event) ->
        length =  $(".selected").length
        length = 1 if length is 0
        $("<span style='white-space:nowrap;'>").text length + "mails"
      revert: "invalid"

displayCalendar = ->
  if ($('.mini-calendar').is(':visible') == true)
    $('.mini-calendar').hide(100, ->
      $('.clams-table').css('width','100%')
    )
  else
    $('.mini-calendar').show(100, ->
      fullCalendar()
      )
    $('.clams-table').css('width','55%')
    $('.clams-table').css('float','right')

submitEvent = ->
  $("#createEventFromMail").modal('hide')

  data = {
    clam_id: $('#createEventFromMail #mail').attr("data-id")
    event:
      summary: $('#createEventFromMail #eventSummary').val()
      dtstart: $('#createEventFromMail #eventStartTime').val()
      dtend: $('#createEventFromMail #eventEndTime').val()
  }

  $ . ajax
    type: 'POST'
    url: '/events'
    data: data
    timeout: 9000
    success: ->
      $("#calendar").fullCalendar('renderEvent',
        {
          title: $('#eventSummary').val()
          start: new Date($('#eventStartTime').val())
          end: new Date($('#eventEndTime').val())
          allDay: ($('#eventAllDay').val() == "true")
        },
        true)
    error: ->
      alert("error")

ready = ->
  initDraggableClam()
  $('.mini-calendar').hide()
  $('.calendar-icon').click ->
    displayCalendar()
  $('#submitButton').click ->
    submitEvent()

$(document).ready(ready)
$(document).on('page:load', ready)
