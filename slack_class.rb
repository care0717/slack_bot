# coding: utf-8
require_relative './schedule_class'
require_relative './bluemix_api'
require_relative './gcp_vision'
require_relative './mylib'
require 'slack'

LAB_URL = 'https://p-grp.nucleng.kyoto-u.ac.jp/lab/'

class SlackFile
  include BluemixVRApi
  def initialize(data)
    @file_mimetype = data['file']['mimetype']
    @file_id = data['file']['id']
  end

  def analyze_by_watson
    if @file_mimetype&.include?("image")
      scores = calc_scores_of_image(@file_id)
      scores.to_s[1..-2].tr(",", "\n").tr("\"", "")
    end
  end

  def analyze_receipt
    if @file_mimetype&.include?("image")
      recipt = deal_receipt(@file_id)
      recipt.to_s[1..-2].tr(",", "\n").tr("\"", "")
    end
  end
end

class SlackText
  include HTTPResources
  def initialize(data)
    @text = data['text'][12..-1]&.strip
    @channel = data['channel']
  end

  def analyze
    case @text
    when '今日', 'mura', 'ゼミ' then
      schedule_html = fetch_html(LAB_URL, ENV['PGRP_ID'], ENV['PGRP_PASS'])
      #puts schedule_html
      #puts schedule_html.css('.schedule')
      html_to_text(schedule_html, @text)
    when /レシートから/ then
      Slack.configure { |config| config.token = ENV['SLACKBOT_TOKEN'] }
      client =  Slack::Client.new
      messages = client.channels_history(channel: "#{@channel}")["messages"]
      bot_message = messages.select{|m| m["username"] == "ruby_bot" && m["text"].include?("receipt") }
      res = bot_message.flat_map{ |bm|
        date = bm["text"].split("\n")[0].sub(/receipt/, "")
        bm["text"].split("\n").select{|m| m.include?(@text.sub(/レシートから/, "").strip)}.unshift(date)}
      res.to_s
    when '説明してください' then
      "精算チャンネルでレシートをアップしろ，そしたらそれを解析してあげよう\n
      さらに「商品名 レシートから」と話しかけろ，そしたらその商品名の税込み価格を教えてあげよう"
    else
      'なんの用だ'
    end

  end

  private
    def html_to_text(html, text)
      case text
      when '今日' then
        schedules = Schedules.new(extract_from_html(html.css('.schedule').search('tr')[1..-1]))
        return schedules.today.to_text
      when 'mura' then
        schedules = Schedules.new(extract_from_html(html.css('.trip_sche').search('tr')[1..-1]))
        return schedules.today.to_text
      when 'ゼミ' then
        schedules = Schedules.new(extract_from_html(html.css('.schedule').search('tr')[1..-1]))
        return schedules.latest_semi.to_text
      end
    end

    def extract_from_html(schedule_html)
      res = []
      schedule_html.each do |each|
        day = Date.parse(each.search('th')[0].content)#.strftime('%m-%d')
        time = each.search('td')[1].content
        content = each.search('td')[2].content
        res.push({ day: day, time: time, content: content })
      end
      return res
    end
end
