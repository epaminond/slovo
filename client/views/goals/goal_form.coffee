Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [
        { _id: { $ne: @goal._id }},
        { userId: Meteor.userId()}
      ]
    ).map (goal)-> {label: goal.title, value: goal._id}
  pctOfParentGoalDisabled: -> !@goal.parentGoalId? || @goal.parentGoalId == ''
  getCssInEms: ($obj, property)-> parseFloat($obj.css property) / parseFloat($obj.css "font-size")
  blockPosition: (parentGoalId)->
    $parentGoalBlock = $("##{parentGoalId}")
    if $parentGoalBlock.length > 0
      sideIndent = Template.goalForm.getCssInEms($parentGoalBlock, 'right') + 10
    else
      sideIndent = 0
    connections = jsPlumb.getConnections(source: parentGoalId)
    topSiblings = connections.map (element) ->
      Template.goalForm.getCssInEms $(element.target), 'top'
    topSiblings = topSiblings.filter (el)-> !isNaN(el)
    highestTop  = if topSiblings.length > 0 then Math.max.apply(Math, topSiblings) else 0
    topIndent = highestTop + 3
    { right: "#{sideIndent}em", top: "#{topIndent}em" }

Template.goalForm.rendered = ->
  AutoForm.resetForm 'goalForm'

  endGoal = @data.goal
  jsPlumb.ready ->
    jsPlumb.Defaults =
      Connector: ["Bezier", curviness: 20]
      PaintStyle:
        strokeStyle: "gray"
        lineWidth: 2
      EndpointStyle:
        fillStyle: "gray"
        radius: 4
      HoverPaintStyle:
        strokeStyle: "#ec9f2e"
      EndpointHoverStyle:
        fillStyle: "#ec9f2e"
      Container: "goal-tree"

    jsPlumb.doWhileSuspended ->
      for goal in Goals.find({$or: [{_id: endGoal._id}, {parentGoalId: endGoal._id}]}).fetch()
        $block = $("<div class=\"block panel panel-default\" id=\"#{goal._id}\"></div>")
        $block.html("<div class=\"col-md-12\">#{goal.title}</div>")
        $block.css Template.goalForm.blockPosition(goal.parentGoalId)
        $('#goal-tree').append $block

        jsPlumb.addEndpoint $block,
          uuid: "#{$block.attr("id")}-left"
          anchor: "Left"
          maxConnections: -1

        if goal.parentGoalId?
          jsPlumb.addEndpoint $block,
            uuid: "#{$block.attr("id")}-right"
            anchor: "Right"
            maxConnections: -1
          jsPlumb.connect uuids: ["#{goal.parentGoalId}-left", "#{goal._id}-right"]
  return

Template.goalForm.events
  'change [name=pctCompleted]': (event)-> $('#js-success-bar').width("#{event.target.value}%")
  'change [name=parentGoalId]': (event)->
    noParent = $('[name=parentGoalId]').val() == ''
    $('[name=pctOfParentGoal]').attr 'disabled', noParent
    $('[name=pctOfParentGoal]').val('') if noParent

AutoForm.hooks
  goalForm:
    before:
      insert: (doc, template)->
        doc.userId    = Meteor.user()._id
        doc.createdAt = moment().toDate()
        doc
    onSuccess: (operation, result, template)-> Router.go 'goals'
    onError: (operation, error, template)-> console.log error
