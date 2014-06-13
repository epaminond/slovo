Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [
        { _id: { $ne: @goal._id }},
        { userId: Meteor.userId()}
      ]
    ).map((goal)-> {label: goal.title, value: goal._id})
  pctCompletedLive: ->
    pctCompletedLive = Session.get "pctCompletedLive"
    if pctCompletedLive? then pctCompletedLive else @goal.pctCompleted
  pctOfParentGoalDisabled: ->
    !@goal.parentGoalId? || @goal.parentGoalId == ''
  rendered: (event)->
    AutoForm.resetForm 'goalForm'
    Session.set "pctCompletedLive", $('[name=pctCompleted]').val()

Template.goalForm.events
  'change [name=pctCompleted]': (event)-> Session.set "pctCompletedLive", event.target.value
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
    onSuccess: (operation, result, template)->
      Session.set "pctCompletedLive", undefined
      Router.go 'goals'
    onError: (operation, error, template)-> console.log error
