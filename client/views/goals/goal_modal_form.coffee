Template.goalModalForm.helpers
  parentGoal:     -> Goals.findOne(@goal.parentGoalId)
  disabledDelete: -> 'disabled' unless @goal._id?

AutoForm.hooks
  goalModalForm:
    before:
      insert: (doc, template)->
        _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
    onSuccess: (operation, result, template)->
      $("#goal-form-modal").modal('hide')
    onError: (operation, error, template)-> console.log error
