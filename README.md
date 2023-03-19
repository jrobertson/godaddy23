# Introducing the GoDaddy23 gem

    require 'godaddy23'

    apikey, secret = 'YOUR-API-KEY', 'secret'
    domain = 'yourdomain.com'

    gd = GoDaddy23::Domains.new(apikey, secret)
    r = gd.details domain
    puts r.inspect

## Resources

* https://rubygems.org/gems/godaddy23 godaddy23

godaddy api domain dns
