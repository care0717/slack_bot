require_relative '../dao/watson_dao'
class WatsonService
  def initialize
    @dao = WatsonDao.new
  end
  def analyze(data)
    file_mimetype = data['file']['mimetype']
    file_id = data['file']['id']
    if @file_mimetype&.include?("image")
      scores = @dao.calc_scores(file_id)
    end
    return scores
  end
end
