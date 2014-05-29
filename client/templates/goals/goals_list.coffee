Template.goalsList.helpers
  goals: -> Goals.find userId: Meteor.userId()
  goalsAny: -> Goals.find(userId: Meteor.userId()).count() > 0

Template.goalsList.events
  'click .js-remove-goal': (event)->
    event.preventDefault()
    Meteor.call 'removeGoal', @_id, (error, a)->
      throwError error.reason if error?
