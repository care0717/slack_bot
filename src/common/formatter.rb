require_relative 'schedule_class'

module Formatter
  def format_scores(scores)
    scores.to_s[1..-2].tr(",", "\n").tr("\"", "")
  end

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

  private
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

