@Goals = new Meteor.Collection 'goals',
  schema:
    userId:
      type: String
      regEx: SimpleSchema.RegEx.Id
    title:
      type: String
      label: "Title"
      max: 100
    description:
      type: String
      label: "Description"
      optional: true
      max: 5000
    parentGoalId:
      type: String
      optional: true
      regEx: SimpleSchema.RegEx.Id
      label: "Parent Goal"
    pctOfParentGoal:
      type: Number
      label: "Percent of Parent Goal"
      optional: true
      min: 0
      max: 100
    pctCompleted:
      type: Number
      label: "Completed"
      min: 0
      max: 100
    createdAt:
      type: Date
      label: "Date, goal was created"

Goals.allow

  # TODO: why doesn't this work?
  # update: @ownsDocument
  # remove: @ownsDocument

  insert: (userId, goal)->
    @ownsDocument(userId, goal)
  update: (userId, goal)->
    @ownsDocument(userId, goal)
  remove: (userId, goal)->
    @ownsDocument(userId, goal)

Goals.deny
  update: (userId, goal, fieldNames)->
    _.without(fieldNames, 'description', 'title',
      'parentGoalId', 'pctCompleted', 'pctOfParentGoal').length > 0
