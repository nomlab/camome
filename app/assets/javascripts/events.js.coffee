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

  $('.fc-event').each ->
    $(this).draggable
      appendTo: 'body'
      zIndex: 999
      revert: true
      helper: 'clone'

  $('#eventStartTime').datetimepicker
    format: "YYYY/MM/DD H:mm"
    icons:
      time: "fa fa-clock-o"
      date: "fa fa-calendar"
      up: "fa fa-chevron-up"
      down: "fa fa-chevron-down"
      previous: "fa fa-chevron-left"
      next: "fa fa-chevron-right"

  $('#eventEndTime').datetimepicker
    format: "YYYY/MM/DD H:mm"
    icons:
      time: "fa fa-clock-o"
      date: "fa fa-calendar"
      up: "fa fa-chevron-up"
      down: "fa fa-chevron-down"
      previous: "fa fa-chevron-left"
      next: "fa fa-chevron-right"

  $('#myTab a:last').tab('show')


  # console.log($('#point_date').position().top)
  # $('#external-events').scrollTop($('#point_date').position().top)

$(document).ready(ready)
$(document).on('page:load', ready)
