Meteor.publish 'goals', (options)->
  Goals.find {}, options

Meteor.publish 'singleGoal', (id)->
  id && Goals.find(id)