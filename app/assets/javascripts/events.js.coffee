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

    eventClick:
      (calEvent) ->
        document.location = "../events/#{calEvent.id}/edit"

    select:
      (start, end, allDay) ->
        starttime = moment(start).format("YYYY/MM/DD H:mm")
        endtime = moment(end).format("YYYY/MM/DD H:mm")
        $('#createEventModal #eventStartTime').val(starttime)
        $('#createEventModal #eventEndTime').val(endtime)
        $('#createEventModal #eventAllDay').val(allDay)
        $('#createEventModal').modal("show")

    drop:
      (date) ->
        duration = $(this).data('event').duration
        origin_dtstart = new Date($(this).data('event').dtstart)
        dtstart = new Date(date)
        dtstart = moment(dtstart).hour(moment(origin_dtstart).hour())
        dtstart = moment(dtstart).minute(moment(origin_dtstart).minute())
        dtend = moment(dtstart).add(duration,'seconds')
        data = {
          event:
            summary: $(this).data('event').title
            dtstart: new Date(dtstart)
            dtend: new Date(dtend)
            origin_event_id: $(this).data('event').id
        }

        $ . ajax
          type: 'POST'
          url: '/events/ajax_create_event_from_old_event'
          data: data
          timeout: 9000
          success: ->
          error: ->
            alert "error"

doSubmit = ->
  $('#submitButton').on 'click', (e) ->
    e.preventDefault()
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

initDraggableOldEvent = ->
  $('.fc-event').each ->
    event = {
      id: $(this).attr("id")
      title: $.trim($(this).text()).match(/.*/).toString()
      dtstart: $(this).attr("dtstart")
      duration: $(this).attr("duration")
      color: "#9FC6E7"
      textColor: "#000000"
    }

    $(this).data('event', event)

    $(this).draggable
      appendTo: "body"
      zIndex: 999
      revert: "invalid"
      helper: "clone"

ready = ->
  fullCalendar()
  doSubmit()
  initDraggableOldEvent()

  $('.right-display').click ->
    $('.side-menu.calendar').css('display','none')
    $('.recurrence.calendar').css('display','')

  $('.left-display').click ->
    $('.side-menu.calendar').css('display','')
    $('.recurrence.calendar').css('display','none')


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
