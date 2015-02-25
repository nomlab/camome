currentMissionForEvent = "nil"

initDraggableEvent = -> $(".draggable-event").draggable
  helper: (event) ->
    $("<span style='white-space:nowrap;'>").text "event"
  revert: true

ready = ->
  initDraggableEvent()

$(document).ready(ready)
$(document).on('page:load', ready)
