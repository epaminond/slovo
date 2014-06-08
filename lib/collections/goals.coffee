@Goals = new Meteor.Collection 'goals'

Goals.allow

  # TODO: why doesn't this work?
  # update: @ownsDocument
  # remove: @ownsDocument

  update: (userId, goal)->
    @ownsDocument(userId, goal)
  remove: (userId, goal)->
    @ownsDocument(userId, goal)

Goals.deny
  update: (userId, goal, fieldNames)->
    _.without(fieldNames, 'description', 'title',
      'parentGoalId', 'pctCompleted', 'pctOfParentGoal').length > 0
