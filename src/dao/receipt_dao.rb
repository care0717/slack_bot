require_relative '../common/gcp_vision_api'
class WatsonDao
  include GcpVisionApi
  def calc_scores(image_file_id)
    calc_scores_of_image(image_file_id)
  end
end
