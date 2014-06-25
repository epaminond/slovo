Template.goalConstructorItem.helpers
  getCssInEms: ($obj, property)-> parseFloat($obj.css property) / parseFloat($obj.css "font-size")
  position: (parentGoalId)->
    $parentGoalBlock = $("##{parentGoalId}")
    if $parentGoalBlock.length > 0
      sideIndent = Template.goalConstructorItem.getCssInEms($parentGoalBlock, 'right') + 10
    else
      sideIndent = 0
    connections = jsPlumb.getConnections(source: parentGoalId)
    topSiblings = connections.map (element) ->
      Template.goalConstructorItem.getCssInEms $(element.target), 'top'
    topSiblings = topSiblings.filter (el)-> !isNaN(el)
    highestTop  = if topSiblings.length > 0 then Math.max.apply(Math, topSiblings) else 0
    topIndent = highestTop + 3
    "right: #{sideIndent}em; top: #{topIndent}em"