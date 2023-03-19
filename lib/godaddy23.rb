#!/usr/bin/env ruby

# file: godaddy23.rb

# see https://developer.godaddy.com/doc/endpoint/domains#/

# For the OTE environment, use   https://api.ote-godaddy.com
# For the production environment, use https://api.godaddy.com

# By default this gem is set for the production environment


require 'net/http'
require 'uri'
require 'json'


module GoDaddy23

  class Domains

    def initialize(apikey, secret, url: 'https://api.godaddy.com')

      @apikey, @secret, @url = apikey, secret, url

    end

    # Retrieve details for the specified Domain
    #
    # curl -X 'GET' \
    #   'https://api.godaddy.com/v1/domains/[MYDOMAIN]' \
    #   -H 'accept: application/json' \
    #   -H 'Authorization: sso-key [APIKEY]:[SECRET]'
    #
    #
    def details(domain)
      submit(domain)
    end

    def submit(s)

      uri = URI.parse(@url + "/v1/domains/" + s)
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      request["Authorization"] = "sso-key %s:%s" % [@apikey, @secret]

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      JSON.parse(response.body, symbolize_names: true)

    end
  end

end

if __FILE__ == $0 then

  apikey, secret, domain = *ARGV
  gd = GoDaddy23::Domains.new(apikey, secret)
  r = gd.details domain
  puts r.inspect

end
