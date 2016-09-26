require 'active_support/inflector'

guard :rspec, cmd: 'bin/rspec' do
  # spec/*_helper.rb -> all specs
  watch(%r{spec/.*_helper.rb})                        { 'spec' }
  # spec/support/*.rb -> all specs
  watch(%r{spec/support/.*.rb})                       { 'spec' }
  # app/**/(application|base)_*.rb--> all relevant spec groups
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
  watch('app/resources/base_resource.rb')             { 'spec/controllers' }
  watch('app/policies/application_policy.rb')         { 'spec/policies' }
  # spec/**/* --> itself
  watch(%r{^spec/.+_spec\.rb$})
  # app/**/* -> corresponding spec
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  # lib/**/* -> corresponding spec
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # app/resources/* and app/policies/* --> controller spec
  watch(%r{^app/resources/(.+)_resource\.rb$})        { |m| "spec/controllers/#{m[1].pluralize}_controller_spec.rb" }
  watch(%r{^app/policies/(.+)_policy\.rb$})           { |m| "spec/controllers/#{m[1].pluralize}_controller_spec.rb" }
end
