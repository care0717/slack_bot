require_relative '../service/receipt_service'
require_relative '../common/formatter'

class ReceiptController
  include Formatter
  def initialize
    @service = ReceiptService.new
  end
  def analyze(data)
    format_scores(@service.analyze(data))
  end
end
  
