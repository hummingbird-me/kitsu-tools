Kibana.configure do |config|
  config.elasticsearch_host = ENV['ELASTICSEARCH_HOST']
  config.elasticsearch_port = 9200
  config.kibana_default_route = '/dashboard/file/logstash.json'
  config.kibana_index = 'kibana-int'
end
