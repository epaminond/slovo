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
  pctOfParentGoalDisabled: ->
    !@parentGoalId? || @parentGoalId == ''

Template.goalEdit.events
  'keyup [name=pctCompleted]': (event)->
    pctCompleted = parseInt $(event.target).val()
    pctCompleted = 0 if isNaN pctCompleted
    Session.set("pctCompletedLive", pctCompleted)

  'change [name=parentGoalId]': (event)->
    noParent = $('[name=parentGoalId]').val() == ''
    $('[name=pctOfParentGoal]').attr 'disabled', noParent
    $('[name=pctOfParentGoal]').val('') if noParent

  'submit form': (event)->

    event.preventDefault()
    $target = $(event.target)

    pctCompleted = parseInt $target.find('[name=pctCompleted]').val()
    pctCompleted = 0 if isNaN pctCompleted
    pctCompleted = 100 if pctCompleted > 100

    pctOfParentGoal = parseInt $target.find('[name=pctOfParentGoal]').val()
    pctOfParentGoal = 0 if isNaN pctOfParentGoal
    pctOfParentGoal = 100 if pctOfParentGoal > 100

    goalProperties =
      title:            $target.find('[name=title]').val()
      description:      $target.find('[name=description]').val()
      parentGoalId:     $target.find('[name=parentGoalId]').val()
      pctCompleted:     pctCompleted
      pctOfParentGoal:  pctOfParentGoal

    Goals.update @_id, {$set: goalProperties}, (error)->
      if error then throwError(error.reason) else
        Router.go 'goals'
