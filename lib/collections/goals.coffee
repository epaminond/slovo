@Goals = new Meteor.Collection 'goals'

Goals.allow
  update: @ownsDocument
  remove: @ownsDocument

Meteor.methods
  addGoal: (goalAttributes)->
    user = Meteor.user()

    if !user
      throw new Meteor.Error(401, "You need to login to post new stories")
    if !goalAttributes.title
      throw new Meteor.Error(422, 'Please fill in a headline')

    goal = _.extend _.pick(goalAttributes, 'title', 'description'),
      userId:     user._id
      submitted:  new Date().getTime()
    Goals.insert goal

  removeGoal: (_id)-> Goals.remove(_id)