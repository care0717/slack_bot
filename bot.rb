require 'slack'
require './responce'
require './homepage_request'

Slack.configure {|config| config.token = ENV['SLACKBOT_TOKEN'] }
client = Slack.realtime

client.on :hello do
  puts 'Successfully connected.'
end


client.on :message do |data|
  if data['text'].include?('<@U7H8F99HT>')
    responce(data)
  end
end

client.start
