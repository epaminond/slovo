Meteor.methods
  addGoal: (goalAttributes)->
    user = Meteor.user()

    if !user
      throw new Meteor.Error(401, "You need to login to set your goals")
    if !goalAttributes.title
      throw new Meteor.Error(422, 'Please fill in a headline')

    safe_attrs = _.pick goalAttributes, 'title', 'description', 'parentGoalId',
      'pctOfParentGoal'
    goal = _.extend safe_attrs,
      userId:     user._id
      submitted:  new Date().getTime()
    Goals.insert goal
