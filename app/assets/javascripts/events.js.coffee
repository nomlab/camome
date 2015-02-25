# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#calendar').fullCalendar
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
        starttime = moment(start).format("YYYY/MM/DD H:mm")
        endtime = moment(end).format("YYYY/MM/DD H:mm")
        $('#createEventModal #eventStartTime').val(starttime)
        $('#createEventModal #eventEndTime').val(endtime)
        $('#createEventModal #eventAllDay').val(allDay)
        $('#createEventModal').modal("show")

  $('#submitButton').on 'click', (e) ->
    e.preventDefault()
    doSubmit()

  doSubmit = ->
    $("#createEventModal").modal('hide')
    console.log($('#eventSummary').val())
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
        alert "error"

    eventClick:
      (calEvent) ->
        document.location = "../events/#{calEvent.id}/edit"

$ ->
  $('#eventStartTime').datetimepicker
    format: "YYYY/MM/DD H:mm"
  $('#eventEndTime').datetimepicker
    format: "YYYY/MM/DD H:mm"

$(document).ready(ready)
$(document).on('page:load', ready)
