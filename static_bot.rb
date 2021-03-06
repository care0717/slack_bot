# coding: utf-8
require 'slack'
require 'open-uri'
require 'nokogiri'

Slack.configure { |config| config.token = ENV['SLACKBOT_TOKEN'] }

def easy_to_use(schedule)
  res = {}
  schedule.each do |each|
    day = Date.parse(each.search('th')[0].content).strftime('%Y-%m-%d')
    time = each.search('td')[1].content
    content = each.search('td')[2].content
    if !res.key?(day)
      res.store(day, [time, content])
    else
      res[day].push(time, content)
    end
  end
  return res
end

def schedule_request(text)
  url = 'https://p-grp.nucleng.kyoto-u.ac.jp/lab/'
  # 取得するhtml用charset
  charset = nil

  fh = open(
    url,
    http_basic_authentication: [ENV['PGRP_ID'], ENV['PGRP_PASS']],
  ).read

  # Nokogiri で切り分け
  case text
  when '予定' then
    schedule_wraped = Nokogiri::HTML.parse(fh, nil, charset).css('.schedule')
    schedule = schedule_wraped.search('tr')[1..-1]
    return easy_to_use(schedule)
  when 'mura' then
    schedule_wraped = Nokogiri::HTML.parse(fh, nil, charset).css('.trip_sche')
    schedule = schedule_wraped.search('tr')[1..-1]
    return easy_to_use(schedule)
  end
end

def post(channel, message)
  params = {
    token: @token,
    channel: channel,
    text: message,
    #:icon_url => 'http://blogs.microsoft.co.il/blogs/shayf/WindowsLiveWriter/GettingStartedWithDynamicLanguages_B665/ruby_logo_2.png'
  }
  Slack.chat_postMessage params
end

schedule = schedule_request('予定')
channel = '#全体'
tommorow = (Date.today + 1).strftime('%Y-%m-%d')
if schedule.key?(tommorow)
  post(channel, '明日の予定')
  post(channel, tommorow[5..-1] + ' ' + schedule[tommorow].join(' '))
end
