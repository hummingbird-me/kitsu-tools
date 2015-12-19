guard :rspec, cmd: 'bin/rspec' do
  # spec/*_helper.rb -> all specs
  watch(%r{spec/.*_helper.rb})                        { 'spec' }
  # spec/support/*.rb -> all specs
  watch(%r{spec/support/.*.rb})                       { 'spec' }
  # app/controllers/application_controller --> all controller specs
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
  # spec/**/* --> itself
  watch(%r{^spec/.+_spec\.rb$})
  # app/**/* -> corresponding spec
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  # lib/**/* -> corresponding spec
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # app/controllers/**/* --> controller spec + acceptance spec
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end
