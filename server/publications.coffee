Meteor.publish 'goals', (options)->
  Goals.find {}, options