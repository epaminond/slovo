@GoalsListController = RouteController.extend
  template: "goalsList"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()
