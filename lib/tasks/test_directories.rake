namespace :test do
  task run: %w(
    test:units test:functionals test:generators test:integration
    test:services test:libs
  )

  desc 'test services'
  Rails::TestTask.new(services: 'test:prepare') do |t|
    t.pattern = 'test/services/**/*_test.rb'
  end

  desc 'test libs'
  Rails::TestTask.new(libs: 'test:prepare') do |t|
    t.pattern = 'test/lib/**/*_test.rb'
  end
end
