require_relative '../dao/text_dao'
class TextService
  def initialize
    @dao = TextDao.new
  end
  def fetch_lab_html
    @dao.fetch_lab_html
  end
  def analyze_receipt_from_history(histories, text)
    # botのメッセージでかつreceiptを含むものを取得
    bot_messages = histories.select{|m| m["username"] == "ruby_bot" && m["text"].include?("receipt") }
    # 取得したい商品名
    target_name = text.sub(/レシートから/, "").strip
    res = bot_messages.flat_map{ |bm|
      bm_text_list = bm["text"].split("\n")
      # レシートを登録した日付
      date = bm_text_list[0].sub(/receipt/, "")
      # bm_text_listのうちほしい商品名を含むものを取得し，先頭にdateをつけて返す
      bm_text_list.select{|m| m.include?(target_name)}.unshift(date)}
  end
  def uranai(channel)
    file = @dao.uranai
    params = {
          token: ENV['PGRP_LEGACY_TOKEN'],
          channels: channel,
          file: file,
          initial_comment: '占い結果です',
        }
  end
end
