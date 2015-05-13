#= require bootstrap-table

initDraggableEvent = ->
  $('.draggable-event').draggable
    helper: (event) ->
      length =  $(".selected").length

      # length = 1 if no check
      length = 1 if length is 0
      $("<span style='white-space:nowrap;'>").text length + "events"
    revert: "invalid"

initDroppableEvent = ->
  $('.recurrence').droppable
    tolerance: 'pointer'
    drop: (event, ui) ->
      events_id = []

      events_id.push ui.draggable.attr("id")
      $('.draggable-event.selected').each ->
        events_id.push $(this).attr("id")

      recurrence_id = @id

      $ . ajax
        type: 'POST'
        url: "/recurrences/add_events"
        data: {
          events_id: events_id
          recurrence_id: recurrence_id
        }
        success: ->
          replaceRecurrenceList()
          replaceEventInbox()
        error: ->
          alert ("error")

initClickNewRecurrence = ->
  $('.new-recurrence').click ->
    $('#createRecurrenceModal').modal("show")

initChangeRecurrenceBox = ->
  $('.recurrence').click ->
    recurrence_id = $(this).attr("id")

    $ . ajax
      type: 'GET'
      url: '/events.json'
      data: {
        recurrence_id: recurrence_id
      }
      success: (data) ->
        events = data.map (event) ->
          """
          <tr class="draggable-event" id="#{event["id"]}">
            <td class="bs-checkbox">
              <input type="checkbox" name="btSelectItem">
            </td>
            <td>#{event["title"]}</td>
            <td>#{event["arrange_date"]}</td>
          </tr>
          """
        $('.event-inbox').replaceWith("<tbody class='event-inbox'>#{events}</tbody>")
        reloadEventList()
      error: ->
        alert("error")

initSubmitRecurrence = ->
  $('#submitRecurrenceButton').click ->
    $("#createRecurrenceModal").modal('hide')
    console.log($('#RecurreceName').val())
    console.log($('#RecurreceDescription').val())

    if $('#RecurreceDescription').val() == null
      description = null
    else
      description = $('#RecurreceDescription').val()

    data = {
      recurrence:
        name: $('#RecurreceName').val()
        description: description
    }

    $ . ajax
      type: 'POST'
      url: '/recurrences'
      data: data
      timeout: 9000
      success: ->
        replaceRecurrenceList()
      error: ->
        alert ("error")

replaceEventInbox = ->
  $ . ajax
    type: 'GET'
    url: '/events.json'
    success: (data) ->
      events = data.map (event) ->
        if event.recurrence_id == null
          """
          <tr class="draggable-event" id="#{event["id"]}">
            <td class="bs-checkbox">
              <input type="checkbox" name="btSelectItem">
            </td>
            <td>#{event["title"]}</td>
            <td>#{event["arrange_date"]}</td>
          </tr>
          """
      $('.event-inbox').replaceWith("<tbody class='event-inbox'>#{events}</tbody>")
      reloadEventList()
    error: ->
      alert("error")

replaceRecurrenceList = ->
  $ . ajax
    type: 'GET'
    url: '/recurrences.json'
    success: (data) ->
      recurrences = data.map (recurrence) ->
        """
         <tr>
          <td class="recurrence" id="#{recurrence["id"]}">#{recurrence["name"]} (#{recurrence["events"]})</td>
        </tr>
        """
      html =
        """
        <tr>
          <td class="new-recurrence"> 新しいリカーレンス </td>
        </tr>
        #{recurrences}
        """
      $('.recurrence-item').replaceWith("<tbody class='recurrence-item'>#{html}</tbody>")
      reloadRecurrenceList()
    error: -> alert ("error")

reloadRecurrenceList = ->
  initChangeRecurrenceBox()
  initClickNewRecurrence()
  initDroppableEvent()

reloadEventList = ->
  $('#table').bootstrapTable()
  initDraggableEvent()

ready = ->
  $('#table').bootstrapTable()
  initDraggableEvent()
  initDroppableEvent()
  initClickNewRecurrence()
  initChangeRecurrenceBox()
  initSubmitRecurrence()


$(document).ready(ready)
$(document).on('page:load', ready)
