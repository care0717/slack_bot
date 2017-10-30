require 'rest-client'
require 'json'
require 'open-uri'
require 'nokogiri'
require_relative './bluemix'


def calc_scores_of_image(image_file_id)
  token = ENV['PGRP_LEGACY_TOKEN']
  public_api_url = "https://slack.com/api/files.sharedPublicURL?token=#{token}&file=#{image_file_id}"
  revoke_api_url = "https://slack.com/api/files.revokePublicURL?token=#{token}&file=#{image_file_id}"

  res = JSON.parse(RestClient.get public_api_url)

  public_url = res["file"]["permalink_public"]
  charset = nil
  fh = open(
    public_url
  ).read
  scores =  request_to_bluemix(Nokogiri::HTML.parse(fh, nil, charset).css('img').attribute("src").value)
  RestClient.get revoke_api_url
  return  scores
end
