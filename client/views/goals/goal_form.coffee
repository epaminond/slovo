Template.goalForm.helpers
  parentGoals: ->
    [{label: '', value: ''}].concat Goals.find(
      $and: [{ _id: { $ne: @goal._id } }, { userId: Meteor.userId() }]
    ).map (goal)-> {label: goal.title, value: goal._id}

  pctOfParentGoalDisabled: -> !@goal.parentGoalId? || @goal.parentGoalId == ''

Template.goalForm.rendered = -> AutoForm.resetForm 'goalForm'

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
        _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
    onSuccess: (operation, result, template)-> Router.go 'goals'
    onError: (operation, error, template)-> console.log error
