return unless Goals.find().count() == 0

now     = new Date().getTime()
girinId = Meteor.users.insert profile: { name: 'Ivan Girin' }

healthId = Goals.insert
  title: 'Save health'
  description: 'Save health and solve existing health problems'
  userId: girinId
  submitted: now - 7 * 3600 * 1000
