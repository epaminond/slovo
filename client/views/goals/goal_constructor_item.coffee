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
  blockDimensions: (goal)->
    getCssPropInEms = ($obj, property)->
      parseFloat($obj.css property) / parseFloat($obj.css "font-size")
    position = (parentGoalId)->
      $block = $("##{parentGoalId}")
      sideIndent = if _($block).any() then getCssPropInEms($block, 'right') + 15 else 0
      usedSpace = $(".goal-block[style*=\"right: #{sideIndent}em\"]").map (i, e)->
        res = getCssPropInEms($(e), 'top') + getCssPropInEms($(e), 'height')
        if _.isNaN(res) then 0 else res
      usedSpace = if _(usedSpace).any() then _.max(usedSpace) else 0
      parentTopIndent = getCssPropInEms($block, 'top')
      topIndent = _.max [usedSpace, parentTopIndent]
      topIndent = 0 if _.isNaN topIndent
      "right: #{sideIndent}em; top: #{topIndent}em"
    getSubtreeIdsRec = (ids)->
      subIds = Goals.find(parentGoalId: {$in: ids}).fetch()
      if _(subIds).any()
        subIds.concat getSubtreeIdsRec(_(subIds).pluck('_id'))
      else
        []
    getSubtreeMaxWidth = (ids)->
      subtreeGoals = getSubtreeIdsRec(ids)
      parentGoalIds = _.chain(subtreeGoals).pluck('parentGoalId').uniq().value()
      _.reject(subtreeGoals, (el)-> _(parentGoalIds).contains(el._id)).length
    "#{position goal.parentGoalId}; height: #{getSubtreeMaxWidth([goal._id]) * 4}em"

Template.goalConstructorItem.events
  'click .goal-block .panel': (event, template) ->
    Session.set 'modalParams', goal: Goals.findOne(template.data._id), action: 'update'
    $('#goal-modal-form').modal('show')
