Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [
        { _id: { $ne: @goal._id }},
        { userId: Meteor.userId()}
      ]
    ).map (goal)-> {label: goal.title, value: goal._id}
  pctOfParentGoalDisabled: -> !@goal.parentGoalId? || @goal.parentGoalId == ''
  rendered: (event)->
    AutoForm.resetForm 'goalForm'

    jsPlumb.ready ->
      instance = jsPlumb.getInstance
        Connector: ["Bezier", curviness: 50]
        PaintStyle:
          strokeStyle: "gray"
          lineWidth: 2
        EndpointStyle:
          fillStyle: "gray"
        HoverPaintStyle:
          strokeStyle: "#ec9f2e"
        EndpointHoverStyle:
          fillStyle: "#ec9f2e"
        Container: "goal-tree"

      instance.doWhileSuspended ->
        data =
          chartWindow1:
            chartWindow2: {}
            chartWindow3: {}

        blocks = $(".block-diagram .block")

        for block in blocks
          instance.addEndpoint block,
            uuid: block.getAttribute("id") + "-right"
            anchor: "Right"
            maxConnections: -1
          instance.addEndpoint block,
            uuid: block.getAttribute("id") + "-left"
            anchor: "Left"
            maxConnections: -1

        instance.connect uuids: ["chartWindow1-left", "chartWindow2-right"]
        instance.connect uuids: ["chartWindow1-left", "chartWindow3-right"]

      jsPlumb.fire "jsPlumbDemoLoaded", instance

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
