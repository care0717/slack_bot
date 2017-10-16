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

def schedule_request
  url = "https://p-grp.nucleng.kyoto-u.ac.jp/lab/"
  #取得するhtml用charset
  charset = nil
  fh = open(
    url,
    :http_basic_authentication => [ENV["PGRP_ID"], ENV["PGRP_PASS"]],
  ).read

  # Nokogiri で切り分け
  return  Nokogiri::HTML.parse(fh, nil, charset)
end

def responce(data, pattern)
  text = data['text'][12..-1].strip
  case text
  when "今日", "mura", "ゼミ" then
    schedule_html = schedule_request
    post(data['channel'], html_to_text(schedule_html, text))
  when "天気" then
    post(data['channel'], "多分晴れ")
  else
    post(data['channel'], "なんの用だ")
  end
end
