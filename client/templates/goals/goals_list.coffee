Template.goalsList.helpers
  noGoals: -> @goals.count() == 0

Template.goalsList.events
  'click .js-remove-goal': (event)->
    Goals.remove @_id, (error, a)-> throwError error.reason if error?

  'click .js-edit-goal': (event)-> Router.go 'goalEdit', _id: @_id
