require 'open-uri'
require 'nokogiri'
module HTTPResources
  def fetch_html(url, id=nil, password=nil)
    charset = nil
    fh = open(
      url,
      http_basic_authentication: [id, password],
    ).read

    # Nokogiri で切り分け
    return  (Nokogiri::HTML.parse(fh, nil, charset))
  end
end
