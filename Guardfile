ignore([%r{log/.*}, %r{tmp/.*}, %r{frontend/tmp/.*}])

guard 'livereload' do
  #watch(%r{app/assets/.+\.(hbs|emblem)$})
  #watch(%r{app/views/.+\.(erb|haml|slim)$})
  #watch(%r{app/helpers/.+\.rb})
  #watch(%r{public/.+\.(css|js|html)})
  #watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  # Ember
  watch(%r{frontend/app/\w+/.+\.(js|hbs)})
end

guard :minitest, spring: true, all_on_start: false do
  watch(%r{test/.*_test\.rb})
  watch(%r{test/test_helper\.rb}) { 'test' }

  # When files change, run the related test
  watch(%r{lib/(.*/)?([^/]+)\.rb}) { |m| "test/lib/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{app/controllers/(.*/)?([^/]+)\.rb}) { |m| a = "test/controllers/#{m[1]}#{m[2]}_test.rb" }
  # Ideally these would trigger both model and controller tests but it looks
  # like we can't trigger multiple things with Guard-MiniTest
  watch(%r{app/models/(.*/)?([^/]+)\.rb}) { |m| "test/models/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{app/(?:factories|fixtures)/(.*/)?([^/]+)\.rb}) { |m| "test/controllers/#{m[1]}#{m[2]}_controller_test.rb" }
end
