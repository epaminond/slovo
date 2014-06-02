Template.goalsList.helpers
  goals:    -> Goals.find userId: Meteor.userId()
  goalsAny: -> Goals.find(userId: Meteor.userId()).count() > 0

Template.goalsList.events
  'click .js-remove-goal': (event)->
    event.preventDefault()
    Goals.remove @_id, (error, a)-> throwError error.reason if error?

  'click .js-edit-goal': (event)->
    event.preventDefault()
    Router.go 'goalEdit', _id: @_id
