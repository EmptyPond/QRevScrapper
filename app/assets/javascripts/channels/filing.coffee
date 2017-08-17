App.filing = App.cable.subscriptions.create "FilingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log data['update'].total_rev
    $('#_' + parseInt(data['update'].id) + " .total_rev").text(parseInt(data['update'].total_rev))

  speak: ->
    @perform 'speak', message: message
