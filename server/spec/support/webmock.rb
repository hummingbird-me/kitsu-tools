require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [
  'robohash.org',
  %r{pigment.github.io/fake-logos},
  'localhost'
])
