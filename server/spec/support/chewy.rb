require 'chewy/rspec'

# Index immediately, since commits don't happen in testing
Chewy.use_after_commit_callbacks = false

# Process indexing requests immediately
Chewy.strategy(:urgent)

# Reset all the indices before we start
Chewy::Index.descendants.each do |index|
  puts "Resetting #{index.name}"
  index.reset!
end
