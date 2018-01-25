require './slack_class'

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
  if data['channel'] == 'C7P01TP8C' && data['text']&.include?('uploaded')
    slack_file = SlackFile.new(data)
    post(data['channel'], slack_file.analyze_by_watson)
  elsif data['channel'] == 'C7R8W166T' && data['text']&.include?('uploaded') && data['text']&.include?('レシート')
    slack_file = SlackFile.new(data)
    post(data['channel'], "receipt #{Date.today}\n" + slack_file.analyze_receipt)
  elsif data['text']&.include?('<@U7H8F99HT>') && !data['text']&.include?('uploaded')
    slack_text = SlackText.new(data)
    post(data['channel'], slack_text.analyze)
  end
end

client.start
