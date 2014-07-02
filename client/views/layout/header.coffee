Template.header.activeRouteClass = ->
  args = _.chain(arguments).slice(0).initial().value()
  active = _.any args, (name) ->
    Router.current() && Router.current().route.name == name
  active && "active"
