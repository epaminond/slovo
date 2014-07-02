Template.goalConstructor.helpers
  inMainFlow: (goal)->
    parentGoal = Goals.findOne(goal.parentGoalId)
    if parentGoal?
      parentGoal.mainChildId == goal._id && @inMainFlow(parentGoal)
    else
      true
  displayGoal: (goal)->
    block = UI.renderWithData Template.goalConstructorItem, goal
    UI.insert block, document.getElementById(jsPlumb.Defaults.Container)

    inMainFlow = @inMainFlow(goal)
    strokeStyle = if inMainFlow then "#428bca" else "gray"

    endpoint = jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-Left",
      anchor: "Left", maxConnections: -1, paintStyle: { fillStyle: strokeStyle }
    endpoint.bind "click", (endpoint)->
      Session.set 'modalParams',
        goal:   { parentGoalId: endpoint.elementId }
        action: 'insert'
      $('#goal-modal-form').modal('show')

    return unless goal.parentGoalId?

    jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-Right",
      anchor: "Right", maxConnections: 1, paintStyle: { fillStyle: strokeStyle, radius: 2 }

    connection = jsPlumb.connect
      uuids: ["#{goal.parentGoalId}-Left", "#{goal._id}-Right"]
      paintStyle:    { strokeStyle: strokeStyle, lineWidth: 3 }
    connection.bind "click", (conn)->
      Goals.update(goal.parentGoalId, $set: { mainChildId: goal._id }) unless inMainFlow

  displayGoalTreeRecursive: (goal)->
    @displayGoal(goal) if goal._id?
    childGoals = Goals.find $and: [ {parentGoalId: {$exists: true}}, {parentGoalId: goal._id} ]
    for childGoal in childGoals.fetch()
      @displayGoalTreeRecursive childGoal
  modalParams: -> Session.get('modalParams') || goal: {}

Template.goalConstructor.rendered = ->
  AutoForm.resetForm 'goalModalForm'

  $(window).bind 'resize', -> jsPlumb.repaintEverything()

  Deps.autorun =>
    $('.goal-block').each (i, block) -> jsPlumb.remove(block)
    jsPlumb.ready =>
      jsPlumb.reset()
      jsPlumb.Defaults =
        Connector:          ["Bezier", curviness: 20]
        Container:          "goal-tree"
        PaintStyle:         { strokeStyle: "gray", lineWidth: 3 }
        EndpointStyle:      { fillStyle:   "gray", radius:    7 }
        HoverPaintStyle:    { strokeStyle: "#428bca" }
        EndpointHoverStyle: { fillStyle:   "#428bca" }
      jsPlumb.setContainer document.getElementById(jsPlumb.Defaults.Container)

      jsPlumb.doWhileSuspended =>
        return unless @data.goal._id?
        Template.goalConstructor.displayGoalTreeRecursive Goals.findOne(@data.goal._id)
        setTimeout (-> jsPlumb.repaintEverything()), 1
