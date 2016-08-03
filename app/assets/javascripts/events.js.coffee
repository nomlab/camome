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
        origin_event_id = $(this).data('event').id
        data = {
          event:
            summary: $(this).data('event').title
            dtstart: new Date(dtstart)
            dtend: new Date(dtend)
            origin_event_id: origin_event_id
        }

        event = createEventFromOldEvent(data)
        clam = getClamRelatedEvent(origin_event_id)
        if (clam.length > 0)
          displayNoticeIconForMail(clam[0], event)

        if !$(this).hasClass('suggest')
          display_events = getSameMissionIdEvents($(this).attr('mission_id'), Number($(this).attr('id')))
          if (display_events.length > 0)
            displayNoticeIconForEvent(display_events, event)

    eventAfterAllRender:
      (view) ->
        target_id = "#start" + view.intervalStart.clone().subtract(1,'years').format("YYYYMM")
        if $(target_id).length
          scrollOldEvents(target_id)
        $('#calendar').droppable
          tolerance: 'pointer'

displayNoticeIconForMail = (clam, event) ->
  $(".calendar-header").prepend("<i class='fa fa-bell fa-2x notice-icon'></i>")
  setInterval (->
    $('.notice-icon').fadeOut(500).fadeIn(500)
  ), 1000

  $(".notice-icon").click ->
    content = """
      「#{event['summary']}」に関して<br>
      メール「#{clam['summary']}」を送信してはどうですか？<br>
      <a href="/mail/new?clam_id=#{clam['id']}">送信する</a>
    """
    $(this).popover({
      html: 'true'
      placement: 'left'
      content: content
     })

getClamRelatedEvent = (id) ->
  res = $ . ajax
    type: 'GET'
    url: "/events/#{id}/clams"
    dataType: "json"
    async: false
    error: ->
      alert("error")
  res.responseJSON

displayNoticeIconForEvent = (display_events,event) ->
  $(".calendar-header").prepend("<i class='fa fa-bell fa-2x notice-icon'></i>")
  setInterval (->
    $('.notice-icon').fadeOut(500).fadeIn(500)
  ), 1000

  d_event = ""
  display_events.forEach (e) ->
    d_event += "<div id='#{e.id}' class='fc-event ui-draggable ui-draggable-handle suggest' mission_id='' duration='86400.0' dtstart='#{moment(e.dtstart).format("YYYY/MM/DD H:mm")}'>
<p class='summary-label'>
#{e.summary}
</p>
</div>
"
  $(".notice-icon").click ->
    content = """
      「#{event['summary']}」に関して<br>
        <div id='suggest-events'>
          #{d_event}
        </div>
        を登録してはどうですか？<br>
    """
    $(this).popover({
      html: 'true'
      placement: 'left'
      content: content
     })
  $(".notice-icon").mouseleave ->
    initDraggableSuggestEvent()

getSameMissionIdEvents = (m_id,e_id) ->
  if m_id
    res = $ . ajax
      type: 'GET'
      url: "/missions/#{m_id}/events"
      dataType: "json"
      async: false
      error: ->
        alert("error")
    res.responseJSON.some (v, i) ->
      if v.id == e_id
        res.responseJSON.splice(i, 1)
    res.responseJSON
  else
    res = ""
    res

createEventFromOldEvent = (data) ->
  res = $ . ajax
    type: 'POST'
    url: '/events/ajax_create_event_from_old_event'
    data: data
    async: false
    timeout: 9000
    error: ->
      alert "error"
  res.responseJSON

scrollOldEvents = (target)->
  current_top = $('#external-events').scrollTop()
  point_date_top = $(target).position().top
  scroll_top = point_date_top + current_top

  console.log("current_top: #{current_top}")
  console.log("point_date_top: #{point_date_top}")
  console.log("scroll_top: #{scroll_top}")

  $('#external-events').scrollTop(scroll_top)

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

initDraggableSuggestEvent = ->
  $('.suggest').each ->
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
      stop: ->
        $(this).remove()

ready = ->
  fullCalendar()
  doSubmit()
  initDraggableOldEvent()

  $('.open-side-menu').click ->
    if ($('.side-menu.calendar').is(':visible') == true)
      $('.side-menu.calendar').hide(200, ->
        $('#calendar').css('width','100%')
        )
    else
      $('.side-menu.calendar').show(200, ->
        view = $('#calendar').fullCalendar('getView')
        target_id = "#start" + view.intervalStart.clone().subtract(1,'years').format("YYYYMM")
        if $(target_id).length
          console.log(target_id)
          scrollOldEvents(target_id)
        )
      $('#calendar').css('width','80%')

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

$(document).ready(ready)
$(document).on('page:load', ready)
