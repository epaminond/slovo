return unless Goals.find().count() == 0

girinId = Meteor.users.insert profile: { name: 'Ivan Girin' }

healthId = Goals.insert
  title: 'Save health'
  description: 'Save health and solve existing health problems'
  userId: girinId
  createdAt: new Date()
