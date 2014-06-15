Session.setDefault "alert",
  level: false
  message: ""

Template.layout.helpers
  alertLevel: ->
    level = Session.get("alert").level
    if level in ["success", "info", "warning", "danger"]
      "alert alert-#{level}"
    else
      "hidden"

  alertMessage: -> Session.get("alert").message

Template.layout.events
  "click button.close": (event)->
    Session.set "alert",
      level: false
      message: ""
