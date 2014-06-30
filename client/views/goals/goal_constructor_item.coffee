Template.goalConstructorItem.helpers
  mainGoalClass: ->
    parentGoal = Goals.findOne @parentGoalId
    if Template.goalConstructor.inMainFlow(@)
      'panel-primary'
    else
      'panel-default'
  getSubtreeLengthRec: (goalId)->
    jsPlumb.getConnections(source: goalId).map (connection)->
      subConnections = getSubtreeLengthRec(connection.targetId)
      if _(subConnections).any() then _(subConnections).max() + 1 else 1
  getSubtreeMaxWidthRec: (ids)->
    subIds = _.chain(ids)
      .map((id)-> _(jsPlumb.getConnections source: id).pluck 'targetId')
      .flatten().value()
    if _(subIds).any() then _.max [subIds.length, getSubtreeMaxWidthRec(subIds)] else 0
  position: (parentGoalId)->
    getCssPropInEms = ($obj, property)->
      parseFloat($obj.css property) / parseFloat($obj.css "font-size")
    $block = $("##{parentGoalId}")

    sideIndent = if _($block).any() then getCssPropInEms($block, 'right') + 16 else 0

    topIndents = jsPlumb.getConnections(source: parentGoalId).
      map((element) -> getCssPropInEms $(element.target), 'top').
      filter((element)-> !isNaN element)
    highestTop = if _(topIndents).any() then _(topIndents).max() else 0
    topIndent = highestTop + 4

    position = "right: #{sideIndent}em; top: #{topIndent}em"
    while _($(".goal-block[style=\"#{position}\"]")).any()
      position = "right: #{sideIndent}em; top: #{topIndent += 4}em"
    position

Template.goalConstructorItem.events
  'click .goal-block': (event, template) ->
    Session.set 'modalParams', goal: Goals.findOne(template.data._id), action: 'update'
    $('#goal-modal-form').modal('show')
