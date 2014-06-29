Template.goalConstructorItem.helpers
  mainGoalClass: ->
    parentGoal = Goals.findOne @parentGoalId
    if Template.goalConstructor.inMainFlow(@)
      'panel-primary'
    else
      'panel-default'
  position: (parentGoalId)->
    getCssPropInEms = ($obj, property)->
      parseFloat($obj.css property) / parseFloat($obj.css "font-size")
    $block = $("##{parentGoalId}")

    sideIndent = if _($block).any() then getCssPropInEms($block, 'right') + 16 else 0

    topIndents = jsPlumb.getConnections(source: parentGoalId).
      map((element) -> getCssPropInEms $(element.target), 'top').
      filter((element)-> !isNaN element)
    highestTop = if _(topIndents).any() then Math.max.apply(Math, topIndents) else 0
    topIndent = highestTop + 4

    position = "right: #{sideIndent}em; top: #{topIndent}em"
    while _($(".goal-block[style=\"#{position}\"]")).any()
      position = "right: #{sideIndent}em; top: #{topIndent += 4}em"
    position

Template.goalConstructorItem.events
  'click .goal-block': (event, template) ->
    Session.set 'modalParams', goal: Goals.findOne(template.data._id), action: 'update'
    $('#goal-modal-form').modal('show')
