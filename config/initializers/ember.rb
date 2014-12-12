EmberCLI.configure do |c|
  c.app :frontend
end

EmberCLI.compile! if Rails.env.production?
