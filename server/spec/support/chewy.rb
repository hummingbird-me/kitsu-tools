Chewy::Index.descendants.each do |index|
  puts "Resetting #{index.name}"
  index.reset!
end
