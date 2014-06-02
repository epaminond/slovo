Template.goalEdit.events
  'submit form': (event)->

    event.preventDefault()

    goalProperties =
      title:        $(event.target).find('[name=title]').val()
      description:  $(event.target).find('[name=description]').val()

    Goals.update @_id, {$set: goalProperties}, (error)->
      if error then throwError(error.reason) else
        Router.go 'goals'
