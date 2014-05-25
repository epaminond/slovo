if Meteor.isClient
  # Template.home.greeting = ()->
    # "Welcome to slovo."

  Template.home.events
    'click #js-home-btn': ()->
      if typeof(console) != 'undefined'
        console.log "You pressed the button"

if Meteor.isServer
  Meteor.startup ()->
    # code to run on server at startup
