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
      month: ''
      week: 'HH:mm'
      day: 'HH:mm'
    events: '/events.json'

    dayClick:
      (date) ->
        $('#create-event-modal').find("input, textarea").val('')
        $('#create-event-modal #event-dtstart').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#create-event-modal #event-dtend').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#create-event-modal').modal("show")

    eventClick: (calEvent) ->
      createEventPopover(calEvent)
      $(".fc-event[event-id=#{calEvent.id}]").popover('toggle')

    dayRender: (date, cell) ->
      cell.droppable
        tolerance: 'pointer'
        drop: (ev, ui) ->
          clam  = getClam(ui.draggable.data('clam').id)
          $('#create-event-modal #event-dtstart').val(moment(date).format("YYYY/MM/DD H:mm"))
          $('#create-event-modal #event-dtend').val(moment(date).format("YYYY/MM/DD H:mm"))
          $('#create-event-modal #event-summary').val(clam.summary)
          $('#create-event-modal #event-description').val(clam.options.description)
          $('.mail').empty().append("<a href='#' id='mail' data-id='#{clam.id}'>#{clam.summary}</a>")
          $('#create-event-modal').modal('show')

    eventRender: (event, element) ->
      element.attr("event-id", event.id)
      element.droppable
        tolerance: 'pointer'
        activeClass: 'ui-state-focus'
        hoverClass: 'ui-state-hover'
        over: ->
          $(".fc-day").droppable("disable")
        out: ->
          $(".fc-day").droppable("enable")
        drop: (ev, ui) ->
          clamId = ui.draggable.data("clam").id
          eventId = event.id
          clamSummary = ui.draggable.data("clam").summary
          eventSummary = event.title
          data = {
            clam_id: clamId
            event: getEvent(eventId)
          }

          patchEvent(eventId, data)
          .done ->
            alert("「#{eventSummary}」に「#{clamSummary}」を関連付けました．")
          .fail ->
            alert("関連付けに失敗しました．")

          $(".fc-day").droppable("enable")

getEvent = (id) ->
  res = $ . ajax
    type: 'GET'
    url: "/events/#{id}.json"
    dataType: "json"
    async: false
    error: ->
      alert("error")
  res.responseJSON

patchEvent = (id, data) ->
  dfd = $.Deferred()
  $ . ajax
    type: "PATCH"
    url: "/events/#{id}"
    data: data
    dataType: "json"
    timeout: 9000
    success: ->
      dfd.resolve()
    error: ->
      dfd.reject()
  dfd.promise()

getClam = (id) ->
  res = $ . ajax
    type: 'GET'
    url: "/clams/#{id}.json"
    dataType: "json"
    async: false
    error: ->
      alert("error")
  res.responseJSON

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
  if ($('.mini-calendar').is(':visible') != true)
    $('.mini-calendar').show(100, ->
      fullCalendar()
      )
    $('.missions-table').hide(100)
    $('.clams-table').css('width','55%')
    $('.clams-table').css('float','right')

displayMissions = ->
  if ($('.missions-table').is(':visible') != true)
    $('.missions-table').show(100)
    $('.mini-calendar').hide(100)
    $('.clams-table').css('width','80%')

submitEvent = ->
  $("#create-event-modal").modal('hide')

  data = {
    clam_id: $('#create-event-modal #mail').attr("data-id")
    event:
      summary: $('#create-event-modal #event-summary').val()
      dtstart: $('#create-event-modal #event-dtstart').val()
      dtend: $('#create-event-modal #event-dtend').val()
      description: $('#create-event-modal #event-description').val()
  }

  $ . ajax
    type: 'POST'
    url: '/events'
    data: data
    dataType: 'json'
    timeout: 9000
    success: ->
      $("#calendar").fullCalendar('refetchEvents')
    error: ->
      alert("error")

showBodyColumns = (clickedClam) ->
  if ($('.clam-body').is(':visible') == true)
    clamBodyId = $('.clam-body').attr('clam-id')
    $(".clam-body").remove()
    return if clamBodyId == clickedClam.attr("data-id")

  clam  = getClam(clickedClam.attr("data-id"))
  source_clam = clam.reuse_source
  events = clam.events

  reuse_source =
    if source_clam?
      "再利用元のメール：<a href='#' class='show-reuse-source' source-id='#{source_clam.id}'>#{source_clam.summary}</a>"
    else ""

  related_tasks =
    if events.length
      buf = "関連するタスク："
      for event in events
        buf += "<a href='#' class='show-related-task' task-id='#{event.id}'>#{event.summary}</a>"
        buf += ", "
      buf.slice(0, -2)
    else ""

  clamBody =
    """
    <tr class='clam-body' clam-id='#{clam.id}' >
      <td colspan='5'>
        <div>
          <pre>
            <table>
              <tr><th>差出人</th><td>#{clam.options.originator}</td></tr>
              <tr><th>件名</th><td>#{clam.summary}</td></tr>
              <tr><th>宛先</th><td>#{clam.options.recipients}</td></tr>
              <tr><td colspan='2'>#{clam.options.description}</td></tr>
            </table>
          </pre>
        </div>
        <div>
          #{reuse_source}
        </div>
        <div>
          #{related_tasks}
        </div>
      </td>
    </tr>
    """

  $(".draggable-clam[data-id=#{clam.id}]").after(clamBody)
  $(".clam-body > td > div").hide().slideDown(200)

changeFixed = (clickedClam) ->
  clickedClam.removeClass("fixed")
  clickedClam.css("font-weight","normal")

  data = {
    clam:
      fixed: true
    }

  $ . ajax
    type: 'PUT'
    url: "/clams/#{clickedClam.attr("data-id")}"
    data: data
    dataType: 'json'
    async: false
    timeout: 9000
    error: ->
      alert("error")

showClamPopover = (clickedClam) ->
  createClamPopover(clickedClam)
  clickedClam.find(".suggest-icon").focus()

createClamPopover = (clickedClam) ->
  clamId = clickedClam.attr("data-id")
  source_clam_id = getClam(clamId).reuse_source.id
  source_event = getClam(source_clam_id).events[0]

  content = """
    「#{source_event.summary}」というタスクを<br>
    登録してはどうでしょうか？<br>
    <div align="right"><a href='javascript:void(0)' clam-id='#{clamId}' source-event-id='#{source_event.id}'>登録する</a>
    <div align="right"><a href="#">今後表示しない</a></div>
  """

  $(".suggest-icon").popover({
    html: 'true'
    trigger: 'focus'
    placement: 'bottom'
    content: content
  })

showEventPopover = (eventId) ->
  $(".fc-event").onReady ->
    event = $('#calendar').fullCalendar('clientEvents', eventId)[0]
    $('#calendar').fullCalendar('gotoDate', event.start)
    $(".fc-event[event-id=#{eventId}]").onReady ->
      $(".fc-event[event-id=#{eventId}]").click()

createEventPopover = (clickedEvent) ->
  ev = getEvent(clickedEvent.id)

  related_clams =
    if ev.clams.length
      buf = "<br>関連するメール:<br>"
      for clam in ev.clams
        buf += "<a href='javascript:void(0)' related-clam-id='#{clam.id}'>#{clam.summary}</a><br>"
      buf
    else ""

  content = """
    #{clickedEvent.start.format('YYYY/MM/DD H:mm')} 〜 #{clickedEvent.end.format('YYYY/MM/DD H:mm')}<br>
    #{related_clams}
    <div align="right"><a href='/events/#{clickedEvent.id}'>詳細</a></div>
  """

  $(".fc-event[event-id=#{clickedEvent.id}]")
  .popover
    html: 'true'
    container: 'body'
    trigger: 'manual'
    placement: 'bottom'
    title: clickedEvent.title
    content: content
  .on 'hidden.bs.popover', ->
    $(this).popover('destroy')

scrollClamsTable = (clamId) ->
  $clamsTable = $('.clams-table .fixed-table-body')
  $clam = $clamsTable.find("[data-id=#{clamId}]")

  $clam.find(".show-clam").click()
  $clamsTable.find(".clam-body").onReady ->
    clamPosition = $clam.offset().top
    tableTop = $clamsTable.find("table tbody").offset().top
    $clamsTable.animate
      scrollTop: clamPosition - tableTop

showEventModal = (clamId,sourceEventId) ->
  clam = getClam(clamId)
  sourceEvent  = getEvent(sourceEventId)
  year = new Date().getFullYear()
  dtstart = new Date(sourceEvent.dtstart).setFullYear(year)
  dtend = new Date(sourceEvent.dtend).setFullYear(year)

  $('#create-event-modal #event-dtstart').val(moment(dtstart).format("YYYY/MM/DD H:mm"))
  $('#create-event-modal #event-dtend').val(moment(dtend).format("YYYY/MM/DD H:mm"))
  $('#create-event-modal #event-summary').val(sourceEvent.summary)
  $('#create-event-modal #event-description').val(sourceEvent.clams[0].options.description)
  $('.mail').empty().append("<a href='#' id='mail' data-id='#{clam.id}'>#{clam.summary}</a>")
  $('#create-event-modal').modal('show')

showRelatedClam = (clamId) ->
  $('.related-clam-field').empty()
  clam = getClam(clamId)
  source_clam = clam.reuse_source
  events = clam.events

  reuse_source =
    if source_clam?
      "再利用元のメール：<a href='#' class='show-reuse-source' source-id='#{source_clam.id}'>#{source_clam.summary}</a>"
    else ""

  related_tasks =
    if events.length
      buf = "関連するタスク："
      for event in events
        buf += "<a href='#' class='show-related-task' task-id='#{event.id}'>#{event.summary}</a>"
        buf += ", "
      buf.slice(0, -2)
    else ""

  reuse_link = "<a href='/mail/new?clam_id=#{clam.id}' class='btn btn-primary fa fa-repeat'></a>"

  clamBody =
    """
    <pre>
      <table>
        <tr><th>差出人</th><td>#{clam.options.originator}</td><td>#{reuse_link}</td></tr>
        <tr><th>件名</th><td>#{clam.summary}</td></tr>
        <tr><th>宛先</th><td>#{clam.options.recipients}</td></tr>
        <tr><td colspan='2'>#{clam.options.description}</td></tr>
      </table>
      <hr width='90%'>
      #{reuse_source}
      #{related_tasks}
    </pre>
    """

  $('.related-clam-field').append(clamBody)

setPaginator = ->
  $('#paginator').on 'ajax:success', (e, result) ->
    $(result.tbody_elements).appendTo('#tbody_elements').hide().fadeIn(1000)
    $('#paginator').html(result.link_to_next_page)
    initDraggableClam()

  $obj = $('.clams-table .fixed-table-body')
  $obj.get(0).onscroll = ->
    scrollPosition = $(this).scrollTop() + $(this).height()
    scrollHeight = this.scrollHeight
    if scrollPosition / scrollHeight == 1
      $('.next-page').click()

ready = ->
  initDraggableClam()
  $('.mini-calendar').hide()
  $('.calendar-icon').click ->
    displayCalendar()
  $('.missions-icon').click ->
    displayMissions()
  $('#submit-button').click ->
    submitEvent()
  $(this).on 'click', '.show-clam', ->
    clam = $(this).parent()
    showBodyColumns(clam)
    if clam.hasClass("fixed")
      changeFixed(clam)
    showClamPopover(clam) if clam.find('.suggest-icon').size()
  $(this).on 'click', '.show-related-task', ->
    $('.calendar-icon').trigger('click')
    showEventPopover($(this).attr('task-id'))
  $(this).on 'click', 'a[related-clam-id]', ->
    showRelatedClam($(this).attr('related-clam-id'))
    $('.related-clam-field').toggle(500)
  $(this).on 'click', 'a[source-event-id]', ->
    showEventModal($(this).attr('clam-id'), $(this).attr('source-event-id'))
  # For paginate
  setPaginator()
  # Bind click event to body to close a popover by clicking outside
  $('body').on 'click', (e) ->
    $('.fc-event').each ->
      if !$(this).is(e.target) and $(this).has(e.target).length == 0 and $('.popover').has(e.target).length == 0 or $(this).length == 0
        $(this).popover('destroy')
    if !$('a[related-clam-id]').is(e.target) and $('.related-clam-field').has(e.target).length == 0
      $('.related-clam-field').hide(500)
  $(this).on 'click', '.fc-right', ->
    $('.popover').remove()

$(document).ready(ready)
$(document).on('page:load', ready)

$.fn.extend
  # Add handler which is called when the element is loaded.
  # This is like "$(document).ready", but this can be used with selecter.
  # Reference: https://github.com/mach3/js-jquery-onready
  onReady: (func, delay = 100, limit = 5000) ->
    s = @selector
    start = (new Date).getTime()

    progress = ->
      e = $(s)
      if e.length
        func.apply(e)
        return
      if (new Date).getTime() - start > limit
        return
      setTimeout(progress, delay)
      return

    progress()
    return
