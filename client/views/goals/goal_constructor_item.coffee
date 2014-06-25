Template.goalConstructorItem.helpers
  getCssInEms: ($obj, property)-> parseFloat($obj.css property) / parseFloat($obj.css "font-size")
  position: (parentGoalId)->
    $parentGoalBlock = $("##{parentGoalId}")
    if $parentGoalBlock.length > 0
      sideIndent = Template.goalConstructorItem.getCssInEms($parentGoalBlock, 'right') + 16
    else
      sideIndent = 0
    topIndents = jsPlumb.getConnections(source: parentGoalId).
      map((element) -> Template.goalConstructorItem.getCssInEms $(element.target), 'top').
      filter((element)-> !isNaN element)
    highestTop  = if topIndents.length > 0 then Math.max.apply(Math, topIndents) else 0
    topIndent = highestTop + 4
    position = "right: #{sideIndent}em; top: #{topIndent}em"
    while $.inArray(position, $('.goal-block').map((i, goalBlock)-> $(goalBlock).attr('style'))) > 0
      topIndent += 4
      position = "right: #{sideIndent}em; top: #{topIndent}em"
    position

Template.goalConstructorItem.events
  'click .js-edit-goal': (event, a, b)->
    console.log 'event, a, b'
    # $(UI.renderWithData(Template.goalModalForm, {action: 'update', goal: Goals.findOne()}).render().toHTML()).modal('show')
