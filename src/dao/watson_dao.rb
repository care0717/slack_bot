require_relative '../common/bluemix_api'
class WatsonDao
  include BluemixVRApi
  def parse(image_file_id)
    analyze_receipt(image_file_id)
  end
end
