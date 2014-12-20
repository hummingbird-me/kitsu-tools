EmberCLI.configure do |c|
  c.app :frontend
  c.build_timeout = 15
end

if ENV['EMBERCLI_COMPILE'] == "1"
  EmberCLI.compile!
end
