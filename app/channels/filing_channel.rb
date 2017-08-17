class FilingChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "filing_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "filing_channel", message: data['message']
  end
end
