GoalsController = RouteController.extend
  onBeforeAction: ->
    unless Meteor.userId()
      Router.go('home')
      Session.set "alert",
        level: "danger"
        message: "Access denied"
  waitOn: -> Meteor.subscribe "goals", userId: Meteor.userId()

@GoalsListController = GoalsController.extend
  template: "goalsList"
  data: ->
    goals: Goals.find userId: Meteor.userId()

@GoalEditController = GoalsController.extend
  template: "goalForm"
  data: ->
    goal: Goals.findOne @params._id
    action: 'update'

@GoalsNewController = GoalsController.extend
  template: "goalForm"
  data:
    action: 'insert'
    goal:
      pctCompleted: 0
