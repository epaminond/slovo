Template.goalNew.helpers
  goals: -> Goals.find userId: Meteor.userId()

Template.goalNew.events
  'change [name=parentGoalId]': (event)->
    noParent = $('[name=parentGoalId]').val() == ''
    $('[name=pctOfParentGoal]').attr 'disabled', noParent
    $('[name=pctOfParentGoal]').val('') if noParent

  'submit form': (event)->

    event.preventDefault()
    $target = $(event.target)

    pctOfParentGoal = parseInt $target.find('[name=pctOfParentGoal]').val()
    pctOfParentGoal = 0 if isNaN pctOfParentGoal
    pctOfParentGoal = 100 if pctOfParentGoal > 100

    goal =
      title:            $target.find('[name=title]').val()
      description:      $target.find('[name=description]').val()
      parentGoalId:     $target.find('[name=parentGoalId]').val()
      pctOfParentGoal:  pctOfParentGoal
      pctCompleted:     0

    Meteor.call 'addGoal', goal, (error, id)->
      if error?
        throwError error.reason
      else
        Router.go 'goals'
