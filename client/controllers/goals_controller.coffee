@GoalsListController = RouteController.extend
  template: "goalsList"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()

@GoalEditController = RouteController.extend
  template: "goalForm"
  waitOn: ->
    Meteor.subscribe "goals", userId: Meteor.userId()
  data: -> Goals.findOne @params._id
  onAfterAction: ->
    Session.set 'goalAction', 'update'

@GoalsNewController = RouteController.extend
  template: "goalForm"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()
  onAfterAction: ->
    Session.set 'goalAction', 'insert'