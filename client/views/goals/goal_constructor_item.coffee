Template.goalConstructorItem.helpers
  position: (parentGoalId)->
    getCssInEms = ($obj, property)->
      parseFloat($obj.css property) / parseFloat($obj.css "font-size")
    $block = $("##{parentGoalId}")

    sideIndent = if _($block).any() then getCssInEms($block, 'right') + 16 else 0

    topIndents = jsPlumb.getConnections(source: parentGoalId).
      map((element) -> getCssInEms $(element.target), 'top').
      filter((element)-> !isNaN element)
    highestTop  = if _(topIndents).any() then Math.max.apply(Math, topIndents) else 0
    topIndent = highestTop + 4

    position = "right: #{sideIndent}em; top: #{topIndent}em"
    while _($(".goal-block[style=\"#{position}\"]")).any()
      position = "right: #{sideIndent}em; top: #{topIndent += 4}em"
    position
