return unless Goals.find().count() == 0

now     = new Date().getTime()
girinId = Meteor.users.insert profile: { name: 'Ivan Girin' }
girin   = Meteor.users.findOne girinId

healthId = Goals.insert
  title: 'Save health'
  description: 'Save health and solve existing health problems'
  userId: girin._id
  submitted: now - 7 * 3600 * 1000
