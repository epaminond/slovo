Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFoundPage"

Router.map ->
  @route "home",  path: "/",                    template:   "home"
  @route "goals", path: "/goals",               controller: GoalsListController
  @route "goalNew", path: "/goals/new",         controller: GoalsNewController
  @route "goalEdit", path: "/goals/:_id/edit",  controller: GoalEditController

Router.onBeforeAction 'loading'
