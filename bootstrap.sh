function install {
	#Postgres
	curl -o- http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list
	sudo apt-get update

	#Install dependencies
	sudo apt-get install -y curl build-essential git libcurl4-openssl-dev libreadline-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev libpq-dev libpq5 python-psycopg2 pgdg-keyring postgresql postgresql-contrib redis-server bundler

	#Install ruby
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	curl -L https://get.rvm.io | bash -s stable --ruby=2.1.3
	source /home/kieran/.rvm/scripts/rvm

	#Setup Postres user
	sudo sed -i 's/md5/trust/g' /etc/postgresql/9.4/main/pg_hba.conf
	sudo sed -i 's/md5/peer/g' /etc/postgresql/9.4/main/pg_hba.conf
	echo "CREATE USER $USER WITH SUPERUSER LOGIN" | sudo -u postgres psql postgres
	echo "select pg_reload_conf();" | sudo -u postgres psql postgres

	#Install node
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.2/install.sh | bash
	source ~/.bashrc
	nvm install 0.12.3
	bash --login
	rvm --default use 2.1.3
	#Install ember and bower
	npm install -g ember-cli bower
	bundle install

	#Database
	bundle exec rake db:create db:structure:load db:seed
	curl -o dump.sql https://slack-files.com/files-pub/T025CNWM0-F04TCL9QX-42e5a92d04/download/dump.sql
	psql -d hummingbird_development < dump.sql

	#Install frontend
	cd frontend
	npm install
	bower install

	#Finished
	cd ..
	echo "Start the server with bundle exec foreman start"
}

read -p "This script is designed for ubuntu 14.04.2 and is only intended to be used for a dev enviroment, do you wish to continue? (y/n)?" choice
case "$choice" in 
  y|Y ) install;;
  n|N ) exit;;
  * ) exit;;
esac
