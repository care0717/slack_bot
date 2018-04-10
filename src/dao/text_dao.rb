require_relative '../common/mylib'
require 'faraday'
class TextDao
  include HTTPResources
  LAB_URL = 'https://p-grp.nucleng.kyoto-u.ac.jp/lab/'
  def fetch_lab_html
    fetch_html(LAB_URL, ENV['PGRP_ID'], ENV['PGRP_PASS'])
  end
  def uranai
    random = Random.new(Time.now.to_i).rand(100)
    file_path = if random <= 20
        "./images/daikyo.jpg"
      elsif random >= 80
        "./images/daikichi.jpg"
      else
        "./images/kichi.jpg"
      end
    Faraday::UploadIO.new(file_path, 'image/jpg')
  end
end
