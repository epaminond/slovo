Template.goalForm.events
  'submit form': (event)->

    event.preventDefault()

    goal =
      title:        $(event.target).find('[name=title]').val()
      description:  $(event.target).find('[name=description]').val()

    Meteor.call 'addGoal', goal, (error, id)->
      if error?
        throwError error.reason
      else
        Router.go 'goals'
