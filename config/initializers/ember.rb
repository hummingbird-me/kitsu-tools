EmberCLI.configure do |c|
  c.app :frontend
end

if ENV['EMBERCLI_COMPILE'] == 1
  EmberCLI.compile!
end
