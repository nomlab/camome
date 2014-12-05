# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#calendar').fullCalendar
    timeFormat:
      month: 'HH:mm'
      week: 'HH:mm'
      day: 'HH:mm'
    events: '/events.json'

    eventClick:
      (calEvent) ->
        document.location = "../events/#{calEvent.id}/edit"

    selectable: true
    selectHelper: true
    ignoreTimezone: false
    dayClick:
      (date, allDay, jsEvent, view) ->
        title = window.prompt("title")
        data = {
          event:
            summary: title
            dtstart: date.format() + "T00:00:00.000Z"
            dtend: date.format() + "T23:59:59.000Z"
        }
        $ . ajax
          type: 'POST'
          url: '/events'
          data: data
          timeout: 9000
          success: ->
            $('#calendar').fullCalendar('refetchEvents');
          error: ->
            alert("error")

$(document).ready(ready)
$(document).on('page:load', ready)
