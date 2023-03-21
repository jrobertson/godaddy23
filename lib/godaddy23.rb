#!/usr/bin/env ruby

# file: godaddy23.rb

# see https://developer.godaddy.com/doc/endpoint/domains#/
# to view or create new API keys, see https://developer.godaddy.com/keys

# For the OTE environment, use   https://api.ote-godaddy.com
# For the production environment, use https://api.godaddy.com

# By default this gem is set for the production environment

# API reference for domains

# available # GET # /v1/domains/available # Determine whether or not the specified domain is available for purchase
# availables # POST # /v1/domains/available # Determine whether or not the specified domains are available for purchase
# n/a # POST # /v1/domains/contacts/validate # Validate the request body using the Domain Contact Validation Schema for  specified domains.
# n/a # POST # /v1/domains/purchase # Purchase and register the specified Domain
# n/a # GET # /v1/domains/purchase/schema/{tld} # Retrieve the schema to be submitted when registering a Domain for the  specified TLD
# n/a # POST # /v1/domains/purchase/validate # Validate the request body using the Domain Purchase Schema for the # specified TLD
# n/a # GET # /v1/domains/suggest # Suggest alternate Domain names based on a seed Domain, a set of keywords, or the # shopper's purchase history
# n/a # GET # /v1/domains/tlds # Retrieves a list of TLDs supported and enabled for sale
# n/a # DELETE # /v1/domains/{domain} # Cancel a purchased domain
# details # GET # /v1/domains/{domain} # Retrieve details for the specified Domain
# n/a # PATCH # /v1/domains/{domain} # Update details for the specified Domain
# n/a # PATCH # /v1/domains/{domain}/contacts # Update domain
# n/a # DELETE # /v1/domains/{domain}/privacy # Submit a privacy cancellation request for the given domain
# n/a # POST # /v1/domains/{domain}/privacy/purchase # Purchase privacy for a specified domain
# n/a # PATCH # /v1/domains/{domain}/records # Add the specified DNS Records to the specified Domain
# replace_records # PUT # /v1/domains/{domain}/records # Replace all DNS Records for the specified Domain
# list_records # GET # /v1/domains/{domain}/records/{type}/{name} # Retrieve DNS Records for the specified Domain, optionally with the specified Type and/or Name
# replace_records # PUT # /v1/domains/{domain}/records/{type}/{name} # Replace all DNS Records for the specified Domain with the specified Type and Name
# n/a # DELETE # /v1/domains/{domain}/records/{type}/{name} # Delete all DNS Records for the specified Domain with the specified Type and Name
# replace_records # PUT # /v1/domains/{domain}/records/{type} # Replace all DNS Records for the specified Domain with the specified Type
# n/a # POST # /v1/domains/{domain}/renew # Renew the specified Domain
# n/a # POST # /v1/domains/{domain}/transfer # Purchase and start or restart transfer process
# n/a # POST # /v1/domains/{domain}/verifyRegistrantEmail # Re-send Contact E-mail Verification for specified Domain


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
      get(domain)
    end
    
    # Retrieve DNS Records for the specified Domain, optionally with the
    # specified Type and/or Name
    #
    #   type: e.g. A
    #   name: e.g. www
    #
    # curl -X 'GET' \
    #   'https://api.godaddy.com/v1/domains/[MYDOMAIN]/records/[TYPE]/[NAME]' \
    #   -H 'accept: application/json' \
    #   -H 'Authorization: sso-key [APIKEY]:[SECRET]
    #
    def list_records(domain, type: nil, name: nil)
      
      uri = domain
      uri += '/records'
      uri += '/' + type if type
      
      if name then
        uri += '/A' if type.nil?
        uri += '/' + name
      end
      
      get(uri)
      
    end
    
    # Replace all DNS Records for the specified Domain with the specified Type and Name
    #
    #   type: e.g. A
    #   name: e.g. www    
    #
    # warning: be careful if you don't supply a type and name as you may 
    #          accidentally remove existing records if they are not being 
    #          updated using the *records* keyword parameter
    #
    # curl -X 'PUT' \
    #   'https://api.godaddy.com/v1/domains/[DOMAIN]/records/[TYPE]/[NAME]' \
    #   -H 'accept: application/json' \
    #   -H 'Content-Type: application/json' \
    #   -H 'Authorization: sso-key [APIKEY]:[SECRET]' \
    #   -d '[
    # {"data":"[NEW_IP]","ttl":600}
    # ]'    
    #
    def replace_records(domain, type: nil, name: nil, records: [])
      
      uri = domain
      uri += '/records'
      uri += '/' + type if type
      
      if name then
        uri += '/A' if type.nil?
        uri += '/' + name
      end
      
      put(uri, records)
    end
    
    private
    
    def get(uri_part)
      r = submit(uri_part) do |uri|
        Net::HTTP::Get.new(uri)        
      end
      JSON.parse(r.body, symbolize_names: true)      
    end
    
    def put(uri_part, payload)
      
      r = submit(uri_part) do |uri|
        request = Net::HTTP::Put.new(uri)        
        request.content_type = "application/json"
        request.body = JSON.dump(payload)
        request
      end
      
    end    

    def submit(s)

      uri = URI.parse(@url + "/v1/domains/" + s)

      request = yield(uri) if block_given?
      request["Accept"] = "application/json"
      request["Authorization"] = "sso-key %s:%s" % [@apikey, @secret]

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end


    end
  end

end

if __FILE__ == $0 then

  apikey, secret, domain = *ARGV
  gd = GoDaddy23::Domains.new(apikey, secret)
  r = gd.details domain
  puts r.inspect

end
