Template.goalForm.helpers

Template.goalForm.rendered = -> AutoForm.resetForm 'goalForm'

Template.goalForm.events
  'change #endGoalPctCompleted': (event)-> $('#js-success-bar').width("#{event.target.value}%")

AutoForm.hooks
  goalForm:
    before:
      insert: (doc, template)->
        _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
    onSuccess: (operation, result, template)-> Router.go 'goals'
    onError: (operation, error, template)-> console.log error
