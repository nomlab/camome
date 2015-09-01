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
        document.location = "../events/#{calEvent.id}"

    drop:
      (date) ->
        clam  = getClam($(this).data('clam').id)
        $('#create-event-modal #event-dtstart').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#create-event-modal #event-dtend').val(moment(date).format("YYYY/MM/DD H:mm"))
        $('#create-event-modal #event-summary').val(clam.summary)
        $('#create-event-modal #event-description').val(clam.options.description)
        $('.mail').append("<a href='#' id='mail' data-id='#{clam.id}'>#{clam.summary}</a>")
        $('#create-event-modal').modal('show')

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
    timeout: 9000
    success: ->
      $("#calendar").fullCalendar('refetchEvents')
    error: ->
      alert("error")

showBodyColumns = (clickedClam) ->
  clam  = getClam(clickedClam.attr("data-id"))
  clamBody =
    """
    <tr class='clam-body'>
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
      </td>
    </tr>
    """

  if ($('.clam-body').is(':visible') == true)
    $(".clam-body").remove()
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

ready = ->
  initDraggableClam()
  $('.mini-calendar').hide()
  $('.calendar-icon').click ->
    displayCalendar()
  $('.missions-icon').click ->
    displayMissions()
  $('#submit-button').click ->
    submitEvent()
  $('.show-clam').click ->
    showBodyColumns($(this).parent())
    if $(this).parent().hasClass("fixed")
      changeFixed($(this).parent())

$(document).ready(ready)
$(document).on('page:load', ready)
