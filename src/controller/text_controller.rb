require_relative '../service/text_service'
require_relative '../common/formatter'

class TextController
  include Formatter
  def initialize
    @service = TextService.new
  end
  def fetch_lab_info(text)
    html_to_text(@service.fetch_lab_html, text)
  end

  def analyze_receipt_from_history(histories, text)
    @service.analyze_receipt_from_history(histories, text).to_s
  end

  def get_uranai_result(channel)
    @service.uranai(channel)
  end
end
  