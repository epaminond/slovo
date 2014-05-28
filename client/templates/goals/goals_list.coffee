Template.goalsList.helpers
  goals: -> Goals.find userId: Meteor.userId()
  goalsAny: -> Goals.find(userId: Meteor.userId()).count() > 0