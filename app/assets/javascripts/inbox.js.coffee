#= require bootstrap-table

currentMissionForEvent = "nil"

initDraggableEvent = -> $(".draggable-event").draggable
  helper: (event) ->
    length =  $(".selected").length

    # length = 1 if no check
    length = 1 if length is 0
    $("<span style='white-space:nowrap;'>").text length + "events"
  revert: true

ready = ->
  initDraggableEvent()
  $('#table').bootstrapTable()

$(document).ready(ready)
$(document).on('page:load', ready)
