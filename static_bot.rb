require 'slack'
require '/Users/asai/Desktop/slack_bot/homepage_request'  

Slack.configure {|config| config.token = ENV["SLACKBOT_TOKEN"] }

def post(channel, message)
  params = {
    :token => @token,
    :channel => channel,
    :username => "ruby_bot",
    :text => message,
    #:icon_url => 'http://blogs.microsoft.co.il/blogs/shayf/WindowsLiveWriter/GettingStartedWithDynamicLanguages_B665/ruby_logo_2.png'
  }
  Slack.chat_postMessage params
end

schedule = schedule_request
if schedule.has_key?(Date.today.strftime("%Y-%m-%d"))
  post("#test", schedule[Date.today.strftime("%Y-%m-%d")].join(" "))
end

