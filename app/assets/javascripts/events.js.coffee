# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#calendar').fullCalendar
    defaultView: 'agendaWeek'
    editable: true
    selectable: true
    timezone: 'local'
    timeFormat:
      month: 'HH:mm'
      week: 'HH:mm'
      day: 'HH:mm'
    events: '/events.json'

    select:
      (start, end, allDay) ->
        starttime = moment(start).format("ddd, MMM d, H:mm")
        endtime = moment(end)
        endtime = endtime.format("ddd, MMM d, H:mm")
        mywhen = starttime + ' - ' + endtime
        $('#createEventModal #eventStartTime').val(start)
        $('#createEventModal #eventEndTime').val(end)
        $('#createEventModal #eventAllDay').val(allDay)
        $('#createEventModal #when').text(mywhen)
        $('#createEventModal').modal("show")

  $('#submitButton').on 'click', (e) ->
    e.preventDefault()
    doSubmit()

  doSubmit = ->
    $("#createEventModal").modal('hide')
    console.log($('#eventStartTime').val())
    console.log($('#eventEndTime').val())
    console.log($('#eventAllDay').val())

    data = {
      event:
        summary: $('#eventSummary').val()
        dtstart: new Date($('#eventStartTime').val())
        dtend: new Date($('#eventEndTime').val())
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

    eventClick:
      (calEvent) ->
        document.location = "../events/#{calEvent.id}/edit"

$(document).ready(ready)
$(document).on('page:load', ready)
