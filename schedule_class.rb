require_relative 'lib'

#スケジュールを集めたクラス
class Schedules < Array
  include ArrayToSelfConvert
  def today
    res = select { |a_sche| a_sche[:day] == Date.today.strftime('%m-%d') }
    return res
  end

  def latest_semi
    Schedules.new([select { |a_sche| a_sche[:content].include?('ゼミ') }[-1]])
  end

  def to_text
    if self.empty?
      return '予定はありません．'
    elsif self.size == 1
      return strip_single_sch(self).values.join(' ')
    else
      res = []
      self.each do |sche|
        res.push(sche.values.join(' '))
      end
      return res.join('¥n')
    end
  end

  def strip_single_sch(array)
    return array[0] if array.class <= Array && array.size == 1
    return array
  end
end
