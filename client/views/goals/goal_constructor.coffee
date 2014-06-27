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
    strokeStyle = if @inMainFlow(goal) then "#d6e9c6" else "gray"

    endpoint = jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-Left",
      anchor: "Left", maxConnections: -1, paintStyle: { fillStyle: strokeStyle }
    endpoint.bind "click", (endpoint)->
      Session.set 'modalParams',
        goal:   { parentGoalId: endpoint.elementId }
        action: 'insert'
      $('#goal-form-modal').modal('show')

    return unless goal.parentGoalId?

    jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-Right",
      anchor: "Right", maxConnections: 1, paintStyle: { fillStyle: strokeStyle }

    connection = jsPlumb.connect
      uuids: ["#{goal.parentGoalId}-Left", "#{goal._id}-Right"]
      paintStyle:    { strokeStyle: strokeStyle, lineWidth: 3 }
    connection.bind "click", (conn)->
      Goals.update(goal.parentGoalId, $set: { mainChildId: goal._id }) unless inMainFlow

  displayGoalTreeRecursive: (goal)->
    @displayGoal(goal)
    for childGoal in Goals.find(parentGoalId: goal._id).fetch()
      @displayGoalTreeRecursive childGoal
  modalParams: -> Session.get('modalParams') || goal: {}

Template.goalConstructor.rendered = ->
  AutoForm.resetForm 'goalModalForm'

  Deps.autorun =>
    $('.goal-block').each (i, block) -> jsPlumb.remove(block)
    jsPlumb.ready =>
      jsPlumb.reset()
      jsPlumb.Defaults =
        Connector:          ["Bezier", curviness: 20]
        Container:          "goal-tree"
        PaintStyle:         { strokeStyle: "gray", lineWidth: 3 }
        EndpointStyle:      { fillStyle:   "gray", radius:    7 }
        HoverPaintStyle:    { strokeStyle: "#d6e9c6" }
        EndpointHoverStyle: { fillStyle:   "#d6e9c6" }
      jsPlumb.setContainer document.getElementById(jsPlumb.Defaults.Container)

      jsPlumb.doWhileSuspended =>
        Template.goalConstructor.displayGoalTreeRecursive(@data.goal)
        setTimeout (-> jsPlumb.repaintEverything()), 1