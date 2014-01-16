ENV['BEANSTALKD_URL'] = "localhost:11300" if ENV['BEANSTALKD_URL'].nil?

$beanstalk = Beaneater::Pool.new
