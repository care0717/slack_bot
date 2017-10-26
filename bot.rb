require 'slack'
require './responce'
require './homepage_request'

Slack.configure { |config| config.token = ENV['SLACKBOT_TOKEN'] }
client = Slack.realtime

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  puts data
  responce(data) if data['text']&.include?('<@U7H8F99HT>')
  responce_by_watson(data) if data['channel'] == 'C7P01TP8C' && data['text']&.include?('uploaded')
end

client.start
