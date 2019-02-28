require 'rspec'
require 'rspec/mocks'
require 'date'
require_relative '../../src/common/schedule_class'

describe Schedules do
  before(:each) do
    today = Date.today
    tommorow = (Date.today+1)
    @schedules = Schedules.new([
        {day:today, time:"19:00", content:"飲み会"},
        {day:tommorow, time:"19:00", content:"ゼミ"}
      ])
  end

  describe '#today' do
    it '今日の予定があれば今日の予定を返す' do
      res = Schedules.new([{day:Date.today, time:"19:00", content:"飲み会"}])
      expect( @schedules.today).to eq(res)
    end
  end
  describe '#latest_semi' do
    it '最新のゼミの予定を返す' do
      res = Schedules.new([{day:(Date.today + 1), time:"19:00", content:"ゼミ"}])
      expect( @schedules.latest_semi).to eq(res)
    end
  end
  describe '#to_text' do
    it '空なら「予定はありません」を返す' do
      empty_Schedules = Schedules.new([])
      res = "予定はありません．"
      expect( empty_Schedules.to_text).to eq(res)
    end
    it '1つの場合のフォーマットを返す' do
      one_schedules = Schedules.new([{day:Date.today, time:"19:00", content:"飲み会"}])
      res = "2018-04-11 19:00 飲み会"
      expect( one_schedules.to_text).to eq(res)
    end
    it '2つの場合のフォーマットを返す' do
      res = "2018-04-11 19:00 飲み会¥n2018-04-12 19:00 ゼミ"
      expect( @schedules.to_text).to eq(res)
    end
  end
end
