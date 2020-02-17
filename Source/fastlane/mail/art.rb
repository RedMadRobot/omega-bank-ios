# Writing a Hypermedia API client in Ruby
# https://robots.thoughtbot.com/writing-a-hypermedia-api-client-in-ruby
require 'net/https'
require 'json'

# {
# 	"title": "Estudo para \"Parti\u00e7\u00e3o da Mon\u00e7\u00e3o\"",
# 	"artist_link": "https://www.google.com/search?q=Almeida+J%C3%BAnior",
# 	"attribution": "Pinacoteca do Estado de S\u00e3o Paulo",
# 	"creator": "Almeida J\u00fanior",
# 	"image": "http://lh5.ggpht.com/uy1HHSegMJjXcnA9U5P2ilmaEZ8km5iVyGhAc6eXJdWWTaZXXFvDWBIQMz2H",
# 	"attribution_link": "collection/pinacoteca-do-estado-de-sao-paulo",
# 	"source": "CI_TAB",
# 	"link": "asset-viewer/6AEpGpxsSyrAaw"
# }
class Art
  def self.load
    uri = URI('https://www.gstatic.com/culturalinstitute/tabext/imax.json')
    req = Net::HTTP::Get.new(uri)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res = http.request(req)

    JSON.parse(res.body, symbolize_names: true).map { |e| Art.new(e) }
  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})"
    []
  end

  def initialize(data)
    @data = data
  end

  def method_missing(method_name, *args, &block)
    if @data.key?(method_name)
      @data[method_name]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @data.key?(method_name)
  end
end
