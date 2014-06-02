Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"

Router.map ->
  @route "home",  path: "/",      controller: StaticsController
  @route "goals", path: "/goals", controller: GoalsListController
  @route "goalNew", path: "/goals/new", template: "goalForm"
  @route "goalEdit", path: "/goals/:_id/edit", controller: GoalEditController

Router.onBeforeAction 'loading'