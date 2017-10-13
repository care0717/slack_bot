require './homepage_request'

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


def responce(data, pattern)
  text = data['text'][12..-1].strip
  case text
  when "予定" then
    schedule = schedule_request
    if schedule.has_key?(Date.today.strftime("%Y-%m-%d"))
      post(data['channel'], schedule[Date.today.strftime("%Y-%m-%d")].join(" "))
    else
      post(data['channel'], "今日の予定はありません")
    end
    
  when "天気" then
    post(data['channel'], "多分晴れ")
  else
    post(data['channel'], "なんの用だ")
  end
end
