require 'gcp/vision'
require 'base64'
require 'rest-client'
require 'json'
require 'open-uri'
require 'nokogiri'

def deal_receipt(image_file_id)
  token = ENV['PGRP_LEGACY_TOKEN']
  public_api_url = "https://slack.com/api/files.sharedPublicURL?token=#{token}&file=#{image_file_id}"
  revoke_api_url = "https://slack.com/api/files.revokePublicURL?token=#{token}&file=#{image_file_id}"

  res = JSON.parse(RestClient.get(public_api_url))

  public_url = res['file']['permalink_public']
  charset = nil
  fh = open(
    public_url
  ).read
  receipt = ocr_receipt(Nokogiri::HTML.parse(fh, nil, charset).css('img').attribute('src').value)
  RestClient.get revoke_api_url
  return receipt
end

def ocr_receipt(url)
  Gcp::Vision.configure do |config|
    config.api_key = ENV['GCP_VISION_TOKEN']
  end

  request = {
    requests: [
      {
        image:{
          content: Base64.encode64(Net::HTTP.get_response(URI.parse(url)).body)
        },
        features: [
          {
            type: "TEXT_DETECTION",
            maxResults: 10
          }
        ]
      }
    ]
  }
  result = Gcp::Vision.annotate_image(request)
  texts = result.responses[0].annotations["textAnnotations"][0]["description"].split(/\R/)
  jans = texts.select {|text| /\d.*JAN/ =~ text }
  hontai= texts.select {|text| (/\d.*JAN/ =~ text) == nil }
  temp = hontai.select {|item| /#|¥.*\d+$/ =~ item }
  irregular = temp.select {|item| (/^#.*\d+$/ =~ item) == nil && (/^¥.*\d+$/ =~ item) == nil }

  hontai = hontai - irregular
  temp = hontai.flat_map{|i| i.split("¥")}
  hontai = temp.flat_map{|i| i.split("#")}.compact.reject(&:empty?)
  temp = irregular.flat_map{|i| i.split("¥")}
  irregular = temp.flat_map{|i| i.split("#")}.compact.reject(&:empty?)
  hontai = hontai + irregular
  prices = hontai.select {|item| /^\d+$/ =~ item }.map { |price| (price.to_i*1.08).ceil}
  products = hontai.select {|item| (/^\d+$/ =~ item) == nil }
  products.size.times { |i|
    if (/^\d\D.*\d+$/ =~ products[i] ) then
      products[i-1] += (" " + products[i])
    end
  }
  products.delete_if {|item| /^\d\D.*\d+$/ =~ item }

  res = {}
  products.size.times{ |i|
    res[products[i]] = prices[i]
  }
  return res
end
