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
    subIds = _(Goals.find(parentGoalId: {$in: ids}).fetch()).pluck('_id')
    if _(subIds).any() then _.max [subIds.length, Template.goalConstructorItem.getSubtreeMaxWidthRec(subIds)] else 0
  position: (parentGoalId)->
    getCssPropInEms = ($obj, property)->
      parseFloat($obj.css property) / parseFloat($obj.css "font-size")
    $block = $("##{parentGoalId}")
    sideIndent = if _($block).any() then getCssPropInEms($block, 'right') + 15 else 0

    usedSpace = $(".goal-block[style*=\"right: #{sideIndent}em\"]").map (i, e)->
      res = getCssPropInEms($(e), 'top') + getCssPropInEms($(e), 'height')
      if _.isNaN(res) then 0 else res
    usedSpace = if _(usedSpace).any() then _.max(usedSpace) else 0
    "right: #{sideIndent}em; top: #{usedSpace}em"
  blockStyle: (goal)->
    template = Template.goalConstructorItem
    position = template.position goal.parentGoalId
    height   = template.getSubtreeMaxWidthRec([goal._id]) * 4
    "#{position}; height: #{height}em"
  collide: (el1, el2)->
    rect1 = el1.getBoundingClientRect()
    rect2 = el2.getBoundingClientRect()
    !(
      rect1.top > rect2.bottom ||
      rect1.right < rect2.left ||
      rect1.bottom < rect2.top ||
      rect1.left > rect2.right
    );

Template.goalConstructorItem.events
  'click .goal-block': (event, template) ->
    Session.set 'modalParams', goal: Goals.findOne(template.data._id), action: 'update'
    $('#goal-modal-form').modal('show')
