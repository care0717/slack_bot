require 'test/unit'
require 'date'

require '../homepage_request'


class TestShedules < Test::Unit::TestCase

  def test_today_schedule
    today = Date.today.strftime('%m-%d')
    tommorow = (Date.today+1).strftime('%m-%d')
    test1 = Schedules.new([
      {day:today, time:"19:00", content:"飲み会"},
      {day:tommorow, time:"19:00", content:"ゼミ"},
      {day:tommorow, time:"19:00", content:"そのた"}
      ])
    empty_case = Schedules.new([])
    assert_equal today+" "+"19:00"+" "+"飲み会" , test1.today.to_text
    assert_equal tommorow+" "+"19:00"+" "+"ゼミ" , test1.latest_semi.to_text
    assert_equal "予定はありません．", empty_case.to_text
  end
end
