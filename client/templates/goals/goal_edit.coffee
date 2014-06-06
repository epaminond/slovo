Template.goalEdit.helpers
  parentGoals: (_id)-> Goals.find
    $and: [
      { _id: { $ne: "2SjsiFyw7xMN9rYf8" }},
      { userId: Meteor.userId()}
    ]
  selectedGoal: (currentParentGoalId)-> currentParentGoalId == @_id
  pctCompletedLive: ->
    pctCompletedLive = Session.get("pctCompletedLive")
    if pctCompletedLive? then pctCompletedLive else @pctCompleted

Template.goalEdit.events
  'keyup [name=pctCompleted]': (event)->
    pctCompleted = parseInt $(event.target).val()
    pctCompleted = 0 if isNaN pctCompleted
    Session.set("pctCompletedLive", pctCompleted)

  'submit form': (event)->

    event.preventDefault()
    $target = $(event.target)
    pctCompleted = parseInt $target.find('[name=pctCompleted]').val()
    pctCompleted = 0 if isNaN pctCompleted
    pctCompleted = 100 if pctCompleted > 100

    goalProperties =
      title:        $target.find('[name=title]').val()
      description:  $target.find('[name=description]').val()
      parentGoalId: $target.find('[name=parentGoalId]').val()
      pctCompleted: pctCompleted

    Goals.update @_id, {$set: goalProperties}, (error)->
      if error then throwError(error.reason) else
        Router.go 'goals'
