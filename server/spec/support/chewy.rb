require 'chewy/rspec'

# Reset all the indices before we start
Chewy::Index.descendants.each do |index|
  puts "Resetting #{index.name}"
  index.reset!
end
