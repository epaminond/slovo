Template.goalEdit.helpers
  parentGoals: (_id)-> Goals.find
    $and: [
      { _id: { $ne: "2SjsiFyw7xMN9rYf8" }},
      { userId: Meteor.userId()}
    ]
  selectedGoal: (currentParentGoalId)-> currentParentGoalId == @_id

Template.goalEdit.events
  'submit form': (event)->

    event.preventDefault()

    goalProperties =
      title:        $(event.target).find('[name=title]').val()
      description:  $(event.target).find('[name=description]').val()
      parentGoalId: $(event.target).find('[name=parentGoalId]').val()

    Goals.update @_id, {$set: goalProperties}, (error)->
      if error then throwError(error.reason) else
        Router.go 'goals'
