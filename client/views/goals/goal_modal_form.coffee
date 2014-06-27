Template.goalModalForm.helpers
  parentGoal: -> Goals.findOne(@goal.parentGoalId)

AutoForm.hooks
  goalModalForm:
    before:
      insert: (doc, template)->
        _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
    onSuccess: (operation, result, template)->
      Template.goalConstructor.displayGoal(Goals.findOne(result))
      $("#goal-form-modal").modal('hide')
    onError: (operation, error, template)-> console.log error
