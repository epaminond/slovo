Template.goalModalForm.helpers
  parentGoal: -> Goals.findOne(@goal.parentGoalId)

AutoForm.hooks
  goalModalForm:
    before:
      insert: (doc, template)->
        doc.userId    = Meteor.user()._id
        doc.createdAt = moment().toDate()
        doc
    onSuccess: (operation, result, template)-> $("##{template.data.doc._id}-modal").modal('hide')
    onError: (operation, error, template)-> console.log error