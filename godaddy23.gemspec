Gem::Specification.new do |s|
  s.name = 'godaddy23'
  s.version = '0.1.1'
  s.summary = 'My first exploration into the GoDaddy API to query domains I own etc.'
  s.authors = ['James Robertson']
  s.files = Dir["lib/godaddy23.rb"]
  s.signing_key = '../privatekeys/godaddy23.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/godaddy23'
end
