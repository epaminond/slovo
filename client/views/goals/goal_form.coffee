Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [{ _id: { $ne: @goal._id } }, { userId: Meteor.userId() }]
    ).map (goal)-> {label: goal.title, value: goal._id}
  displayGoalTreeRecursive: (instance, goal)->
    block = UI.renderWithData Template.goalConstructorItem, goal: goal, instance: instance
    UI.insert block, document.getElementById('goal-tree')

    instance.addEndpoint block.dom.elements(),
      uuid: "#{goal._id}-left"
      anchor: "Left"
      maxConnections: -1
    if goal.parentGoalId?
      instance.addEndpoint block.dom.elements(),
        uuid: "#{goal._id}-right"
        anchor: "Right"
        maxConnections: -1
      instance.connect uuids: ["#{goal.parentGoalId}-left", "#{goal._id}-right"]

    for childGoal in Goals.find(parentGoalId: goal._id).fetch()
      Template.goalForm.displayGoalTreeRecursive(instance, childGoal)

  pctOfParentGoalDisabled: -> !@goal.parentGoalId? || @goal.parentGoalId == ''

Template.goalForm.rendered = ->
  AutoForm.resetForm 'goalForm'

  endGoal = @data.goal
  jsPlumb.ready ->
    @instance = jsPlumb.getInstance
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

    @instance.doWhileSuspended -> Template.goalForm.displayGoalTreeRecursive(@instance, endGoal)
  return

Template.goalForm.events
  'change #endGoalPctCompleted': (event)-> $('#js-success-bar').width("#{event.target.value}%")
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
