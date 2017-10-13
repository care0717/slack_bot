#webに接続するためのライブラリ
require "open-uri"
#クレイピングに使用するライブラリ
require "nokogiri"


def easy_to_use(schedule)
  res = {}
  schedule.each{ |each|
    day = Date.parse(each.search("th")[0].content).strftime("%Y-%m-%d")
    time = each.search("td")[1].content
    content = each.search("td")[2].content
    res.store(day, [time, content])
  }
  return res
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
  schedule_wraped = Nokogiri::HTML.parse(fh,nil,charset).search("table")[2]
  schedule = schedule_wraped.search("tr")[1..-1]
  return easy_to_use(schedule)
end
