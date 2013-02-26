require 'image_optim'

desc "Optimize all images in the public folder"
task :image_optim do |t|
  system "bundle exec image_optim --no-pngout -r -v app/assets/"
  system "bundle exec image_optim --no-pngout -r -v public/"
end
