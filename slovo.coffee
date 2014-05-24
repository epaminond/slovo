if Meteor.isClient
  # Template.hello.greeting = ()->
    # "Welcome to slovo."

  Template.hello.events
    'click #js-hello-btn': ()->
      if typeof(console) != 'undefined'
        console.log "You pressed the button"

if Meteor.isServer
  Meteor.startup ()->
    # code to run on server at startup
