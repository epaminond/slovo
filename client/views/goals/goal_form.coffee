Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [
        { _id: { $ne: @goal._id }},
        { userId: Meteor.userId()}
      ]
    ).map (goal)-> {label: goal.title, value: goal._id}
  displayGoalTreeRecursive: (goal)->
    $block = $ UI.renderWithData(Template.goalConstructorItem, goal).render().toHTML()
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

    for childGoal in Goals.find(parentGoalId: goal._id).fetch()
      Template.goalForm.displayGoalTreeRecursive(childGoal)

  pctOfParentGoalDisabled: -> !@goal.parentGoalId? || @goal.parentGoalId == ''

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

    jsPlumb.doWhileSuspended -> Template.goalForm.displayGoalTreeRecursive(endGoal)
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
