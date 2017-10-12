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
  text = data['text'][13..-1]
  if pattern.has_key?(text)
    post(data['channel'], pattern[text])
  else
    post(data['channel'], "なんの用だ")
  end
end
