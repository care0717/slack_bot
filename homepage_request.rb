require 'open-uri'
require 'nokogiri'
require './lib'

def to_schedules(schedule)
  res = Schedules.new([])
  schedule.each do |each|
    day = Date.parse(each.search('th')[0].content).strftime('%m-%d')
    time = each.search('td')[1].content
    content = each.search('td')[2].content
    res.push({day: day, time: time, content: content})
  end
  return res
end

#スケジュールを集めたクラス
class Schedules < Array
  include ArrayToSelfConvert
  def today
    res = select { |a_sche| a_sche[:day] == Date.today.strftime('%m-%d') }
    res.each { |a_sche| a_sche.delete(:day) }
    return res
  end

  def latest_semi
    [select { |a_sche| a_sche[:content].include?('ゼミ') }[-1]]
  end
end

def to_text(schedules)
  if schedules.empty?
    return '今日の予定はありません．'
  elsif schedules.size == 1
    return strip_single_sch(schedules).values.join(' ')
  else
    res = []
    schedules.each do |sche|
      res.push(sche.values.join(' '))
    end
    return res.join('¥n')
  end
end

def strip_single_sch(array)
  return array[0] if array.class <= Array && array.size == 1
  return array
end

def html_to_text(schedule_html, text)
  case text
  when '今日' then
    schedule = to_schedules(schedule_html.css('.schedule').search('tr')[1..-1])
    return to_text(schedule.today)
  when 'mura' then
    schedule = to_schedules(schedule_html.css('.trip_sche').search('tr')[1..-1])
    return to_text(schedule.today)
  when 'ゼミ' then
    schedule = to_schedules(schedule_html.css('.schedule').search('tr')[1..-1])
    return to_text(schedule.latest_semi)
  end
end
