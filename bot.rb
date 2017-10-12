require 'slack'
Slack.configure {|config| config.token = ENV[] }
client = Slack.realtime

client.on :hello do
  puts 'Successfully connected.'
end

def post(channel, message)
  params = {
    :token => @token,
    :channel => channel,
    :username => "ruby-my-bot",
    :text => message,
    :icon_url => 'http://blogs.microsoft.co.il/blogs/shayf/WindowsLiveWriter/GettingStartedWithDynamicLanguages_B665/ruby_logo_2.png'
  }
  Slack.chat_postMessage params
end

client.on :message do |data|
  if data['text'].include?("Hello bot")
    post(data['channel'], "hi")
  end
end

client.start
