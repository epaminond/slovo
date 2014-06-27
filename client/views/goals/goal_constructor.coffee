Template.goalConstructor.helpers
  displayGoal: (goal)->
    block = UI.renderWithData Template.goalConstructorItem, goal
    UI.insert block, document.getElementById(jsPlumb.Defaults.Container)

    endpoint = jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-left",
      anchor: "Left", maxConnections: -1
    endpoint.bind "click", (endpoint)->
      Session.set 'modalParams',
        goal:   { parentGoalId: endpoint.elementId }
        action: 'insert'
      $('#goal-form-modal').modal('show')

    if goal.parentGoalId?
      jsPlumb.addEndpoint block.dom.elements(), uuid: "#{goal._id}-right",
        anchor: "Right", maxConnections: 1
      connection = jsPlumb.connect uuids: ["#{goal.parentGoalId}-left",
        "#{goal._id}-right"]
      connection.bind "click", (conn)->
        console.log("you clicked on ", conn);

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
      jsPlumb.Defaults =
        Connector:          ["Bezier", curviness: 20]
        Container:          "goal-tree"
        PaintStyle:         { strokeStyle: "gray", lineWidth: 3 }
        EndpointStyle:      { fillStyle:   "gray", radius:    7 }
        HoverPaintStyle:    { strokeStyle: "#ec9f2e" }
        EndpointHoverStyle: { fillStyle:   "#ec9f2e" }
      jsPlumb.setContainer document.getElementById(jsPlumb.Defaults.Container)

      jsPlumb.doWhileSuspended =>
        Template.goalConstructor.displayGoalTreeRecursive(@data.goal)
        setTimeout (-> jsPlumb.repaintEverything()), 1
