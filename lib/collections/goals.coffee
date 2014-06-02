@Goals = new Meteor.Collection 'goals'

Goals.allow
  # TODO: try to use validation instead of method
  # insert: (userId, goal)->
  #   goal.title?

  # TODO: why doesn't this work?
  # update: @ownsDocument
  # remove: @ownsDocument
  update: (userId, goal)->
    @ownsDocument(userId, goal)
  remove: (userId, goal)->
    @ownsDocument(userId, goal)

Goals.deny
  # insert: (userId, goal, fieldNames)->
  #   _.without(fieldNames, 'description', 'title').length > 0
  update: (userId, goal, fieldNames)->
    _.without(fieldNames, 'description', 'title').length > 0
