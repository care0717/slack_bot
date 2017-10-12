require 'slack'
require 'json'
require './responce'

Slack.configure {|config| config.token = ENV["SLACKBOT_TOKEN"] }
client = Slack.realtime

client.on :hello do
  puts 'Successfully connected.'
end


pattern = {}
pattern["天気"] = "多分晴れ"

client.on :message do |data|
  if data['text'].include?("<@U7H8F99HT>")
    responce(data, pattern)
  end
end

client.start
