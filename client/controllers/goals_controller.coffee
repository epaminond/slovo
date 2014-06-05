@GoalsListController = RouteController.extend
  template: "goalsList"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()

@GoalEditController = RouteController.extend
  template: "goalEdit"
  waitOn: ->
    [
      Meteor.subscribe "singleGoal", @params._id
      Meteor.subscribe "goals", userId: Meteor.userId()
    ]
  data: -> Goals.findOne @params._id

@GoalsNewController = RouteController.extend
  template: "goalNew"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()