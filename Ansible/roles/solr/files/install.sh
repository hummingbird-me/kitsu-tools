if [ ! -d "/usr/share/solr" ]; then
  cd ~
  wget http://apache.osuosl.org/lucene/solr/4.2.1/solr-4.2.1.tgz
  tar -xzvf solr-4.2.1.tgz
  mkdir /usr/share/solr
  cd /usr/share/solr
  unzip ~/solr-4.2.1/example/webapps/solr.war
  mkdir -p /usr/share/solr/hummingbird
  cp -R ~/solr-4.2.1/example/solr/collection1/conf /usr/share/solr/hummingbird
fi
