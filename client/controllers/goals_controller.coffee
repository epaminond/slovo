@GoalsListController = RouteController.extend
  template: "goalsList"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()

@GoalEditController = RouteController.extend
  template: "goalForm"
  waitOn: ->
    Meteor.subscribe "goals", userId: Meteor.userId()
  data: ->
    goal: Goals.findOne @params._id
    action: 'update'

@GoalsNewController = RouteController.extend
  template: "goalForm"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()
  data:
    action: 'insert'
    goal: null
