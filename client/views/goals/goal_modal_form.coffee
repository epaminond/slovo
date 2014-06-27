Template.goalModalForm.helpers
  parentGoal:     -> Goals.findOne(@goal.parentGoalId)
  disabledDelete: -> 'disabled' unless @goal._id?
  removeSubtree:  (goal)->
    Goals.find(parentGoalId: goal._id).forEach (el)->
      Template.goalModalForm.removeSubtree(el)
      Goals.remove el._id

AutoForm.hooks
  goalModalForm:
    before:
      insert: (doc, template)->
        _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
    after:
      remove: (error, result, template)->
        Template.goalModalForm.removeSubtree template.data.doc
    onSuccess: (operation, result, template)->
      $("#goal-form-modal").modal('hide')
    onError: (operation, error, template)-> console.log error
