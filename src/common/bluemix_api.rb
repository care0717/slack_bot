require 'rest-client'
require 'json'
require 'open-uri'
require 'nokogiri'

module BluemixVRApi
  def calc_scores_of_image(image_file_id)
    token = ENV['PGRP_LEGACY_TOKEN']
    public_api_url = "https://slack.com/api/files.sharedPublicURL?token=#{token}&file=#{image_file_id}"
    revoke_api_url = "https://slack.com/api/files.revokePublicURL?token=#{token}&file=#{image_file_id}"

    res = JSON.parse(RestClient.get(public_api_url))
    public_url = res['file']['permalink_public']
    charset = nil
    fh = open(
      public_url
    ).read
    scores = request_to_bluemix(Nokogiri::HTML.parse(fh, nil, charset).css('img').attribute('src').value)
    RestClient.get revoke_api_url
    scores
  end

  private

  def post_bluemix(image_path)
    res = JSON.parse(RestClient.get(
                       'https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify',
                       params: {
                         api_key: ENV['VR_BLUEMIX_KEY'],
                         version: '2016-05-20',
                         url: image_path
                       }
    ))
    res
  end

  def request_to_bluemix(image_path)
    responce = post_bluemix(image_path)
    scores = responce['images'][0]['classifiers'][0]['classes']
    res = {}
    scores.each do |score|
      res[score['class']] = score['score']
    end
    res
  end
end
