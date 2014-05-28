Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"

Router.map ->
  @route "home",  path: "/",      controller: StaticsController
  @route "goals", path: "/goals", controller: GoalsListController

Router.onBeforeAction 'loading'