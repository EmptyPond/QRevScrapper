App.filing = App.cable.subscriptions.create "FilingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if (data['update'].ticker == "No form found") 
    then $('#_' + parseInt(data['update'].id) + " .ticker").text(data['update'].ticker);$('#_' + parseInt(data['update'].id) + " .total_rev").text("")
    else
      $('#_' + parseInt(data['update'].id) + " .total_rev").html("<b>Total Revenue: </b>" + parseInt(data['update'].total_rev))
