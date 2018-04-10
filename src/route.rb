require_relative './controller/watson_controller'
require_relative './controller/receipt_controller'
require_relative './controller/text_controller'

module Route
  def routing(data, histories)
    channel = data['channel']
    text = data['text']
    if channel == ENV['WATSON_CHANNEL'] && text&.include?('uploaded')
      controller = WatsonController.new
      return controller.analyze(data), nil
    elsif channel == ENV['RECEIPT_CHANNEL'] && text&.include?('uploaded') && text&.include?('レシート')
      controller = ReceiptController.new
      return controller.analyze(data), nil
    elsif text&.include?('<@U7H8F99HT>') && !(text&.include?('uploaded'))
      controller = TextController.new
      text = text[12..-1]&.strip
      case text
      when '今日', 'mura', 'ゼミ' then
        return controller.fetch_lab_info(text), nil
      when /レシートから/ then
        return controller.analyze_receipt_from_history(histories, text), nil
      when '占い' then
        return "", controller.get_uranai_result(channel)
      when '説明してください' then
        return "精算チャンネルでレシートをアップしろ，そしたらそれを解析してあげよう\n
        さらに「商品名 レシートから」と話しかけろ，そしたらその商品名の税込み価格を教えてあげよう", nil
      else
        puts "a"
        return 'なんの用だ', nil
      end
    else
      return "",nil
    end
  end
end
