Meteor.publish 'goals', (options)->
  Goals.find { userId: options.userId }, options

Meteor.publish 'singleGoal', (id)->
  id && Goals.find(id)