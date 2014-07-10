Template.goalModalForm.helpers
  parentGoal:     -> Goals.findOne(@goal.parentGoalId)
  disabledDelete: -> 'disabled' unless @goal._id?
  removeSubtree:  (goal)->
    return unless goal._id?
    Goals.find(parentGoalId: goal._id).forEach (el)->
      Template.goalModalForm.removeSubtree(el)
      Goals.remove el._id

Template.goalModalForm.events
  'hidden.bs.modal #goal-modal-form': (e)-> delete Session.keys['modalParams']

AutoForm.addHooks ['goalModalForm', 'goalModalRemoveForm'],
  before:
    insert: (doc, template)->
      _(doc).extend userId: Meteor.user()._id, createdAt: moment().toDate()
  after:
    remove: (error, result, template)->
      Template.goalModalForm.removeSubtree(template.data.doc)
      Router.go('goals') if result == 1 && !template.data.doc.parentGoalId?
  onSuccess: (operation, result, template)->
    $("#goal-modal-form").modal('hide')
  onError: (operation, error, template)-> console.log error
