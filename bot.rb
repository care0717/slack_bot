require 'slack'
require './responce'
require './homepage_request'

Slack.configure { |config| config.token = ENV['SLACKBOT_TOKEN'] }
client = Slack.realtime

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  responce(data) if data['text'].include?('<@U7H8F99HT>')
end

client.start
