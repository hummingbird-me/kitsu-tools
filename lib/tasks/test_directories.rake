namespace :test do
  desc 'test services'
  Rails::TestTask.new(services: 'test:prepare') do |t|
    t.pattern = 'test/services/**/*_test.rb'
  end

  desc 'test lib'
  Rails::TestTask.new(lib: 'test:prepare') do |t|
    t.pattern = 'test/lib/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ['test:lib', 'test:services']
