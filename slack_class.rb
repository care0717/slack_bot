require_relative './schedule_class'
require_relative './get_scores'
require_relative './mylib'

LAB_URL = 'https://p-grp.nucleng.kyoto-u.ac.jp/lab/'

class SlackFile
  def initialize(data)
    @file_mimetype = data['file']['mimetype']
    @file_id = data['file']['id']
  end

  def analyze_by_watson
    if @file_mimetype&.include?("image")
      scores = calc_scores_of_image(@file_id)
      scores.to_s[1..-2].tr(",", "\n")
    end
  end
end

class SlackText
  include HTTPResources
  def initialize(data)
    @text = data['text']
  end

  def analyze
    text = @text[12..-1]&.strip
    case text
    when '今日', 'mura', 'ゼミ' then
      schedule_html = fetch_html(LAB_URL, ENV['PGRP_ID'], ENV['PGRP_PASS'])
      #puts schedule_html
      #puts schedule_html.css('.schedule')
      html_to_text(schedule_html, text)
    when '天気' then
      '多分晴れ'
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
        day = Date.parse(each.search('th')[0].content).strftime('%m-%d')
        time = each.search('td')[1].content
        content = each.search('td')[2].content
        res.push({ day: day, time: time, content: content })
      end
      return res
    end
end
