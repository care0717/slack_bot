require_relative './src/route'
require 'slack'

include Route

Slack.configure { |config| config.token = ENV['SLACKBOT_TOKEN'] }
client = Slack.realtime

def post(channel, message)
  params = {
    token: @token,
    channel: channel,
    username: 'ruby_bot',
    text: message,
  }
  Slack.chat_postMessage params
end

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  puts data
  channel = data['channel']
  temp_client = Slack::Client.new
  histories = temp_client.channels_history(channel: "#{channel}")["messages"]
  message, file_upload_param = routing(data, histories)
  if file_upload_param
    Slack.files_upload(file_upload_param)
  end
  post(channel, message)
end

client.start
