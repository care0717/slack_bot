require 'rest-client'
require 'json'

def post_bluemix(image_path)
  res =  JSON.parse(RestClient.get(
    "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify",
    params: {
      :api_key => ENV['VR_BLUEMIX_KEY'],
      :version => "2016-05-20",
      :url => image_path
      }
    ))
  return res
end

def request_to_bluemix(image_path)
  responce = post_bluemix(image_path)
  scores = responce["images"][0]["classifiers"][0]["classes"]
  res = {}
  scores.each do |score|
    res[score["class"]] = score["score"]
  end
  return res
end
