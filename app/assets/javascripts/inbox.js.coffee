#= require bootstrap-table

initDraggableEvent = -> $('.draggable-event').draggable
  helper: (event) ->
    length =  $(".selected").length

    # length = 1 if no check
    length = 1 if length is 0
    $("<span style='white-space:nowrap;'>").text length + "events"
  revert: true

initCreateRecurrence = ->
  $('.new-recurrence').click ->
    $('#createRecurrenceModal').modal("show")

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
      success: -> replaceRecurrenceList()
      error: ->
        alert "error"

replaceRecurrenceList = ->
  $ . ajax
    type: 'GET'
    url: '/recurrences.json'
    dateType: 'json'
    success: (data) ->
      recurrences = data.map (recurrence) ->
        """
        <tr class="recurrence" id="#{recurrence["id"]}">
          <td>#{recurrence["name"]}</td>
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
    error: -> alert error

ready = ->
  initDraggableEvent()
  $('#table').bootstrapTable()
  initCreateRecurrence()

$(document).ready(ready)
$(document).on('page:load', ready)
