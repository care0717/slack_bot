require_relative '../service/watson_service'
require_relative '../common/formatter'

class WatsonController
  include Formatter
  def initialize
    @service = WatsonService.new
  end
  def analyze(data)
    format_scores(@service.analyze(data))
  end
end
  
