namespace :test do
  desc "test lib"
  Rake::TestTask.new(:lib) do |t|
    t.libs << "test"
    t.pattern = 'test/lib/**/*_test.rb'
    t.verbose = true
  end

  desc "test services"
  Rake::TestTask.new(:services) do |t|
    t.libs << "test"
    t.pattern = 'test/services/**/*_test.rb'
    t.verbose = true
  end
end

Rake::Task[:test].enhance do
  Rake::Task["test:lib"].invoke
  Rake::Task["test:services"].invoke
end
