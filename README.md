### Setting up a development environment on OS X

* Install `Homebrew`: http://brew.sh/
* Install `Ruby 2.1.0` using RVM: https://rvm.io/rvm/install
* Using `Homebrew`, install the following: `git`,  `curl`, `v8`, `beanstalkd`, `redis`
* Install `Postgres.app`: http://postgresapp.com/
* Get a database dump from Vikhyat and load it into Postgres.
* In terminal
 * `cat ~/Downloads/dump-.... | gzip -d | /Applications/Postgres.app/Contents/MacOS/bin/psql`
 * `cd hummingbird && bundle install`
 * `bundle exec foreman start`


### Setting up a development environment on Windows
This setup is using `Ubuntu` running inside `VirtualBox` on a Windows machine.  
Cursiv lines are bugfixes and/or optional, just read them carefully and decide what to do.

* Make sure that you have enabled the `VT-x` / `AMD-v` settings in your BIOS,  
 otherwise VirtualBox will not boot correctly.
* Download a copy of `Ubuntu` from http://www.ubuntu.com/download/desktop
* Download and Install `VirtualBox` from http://virtualbox.org
* Open `VirtualBox` and create a new `Virtual Machine (VM)`.
 * You can choose whatever name you want but make sure to set the `type` to `other` and the `version` to `Other/Unknown (64bit)` even though it has an Ubuntu option
 * All other settings don't need to be changed, you can however adjust the RAM and disk size for your need.
* Start your new VM and select the `Ubuntu image` you previously downloaded and run through the setup.
* Open the VM's network settings (`Machine > Settings > Network`) and change the type of the adapter to `bridge`.
* Select `Device > Insert medium with guest extension` and run through the setup.
	* *If this isn't working, navigate to `/media/VBOXADDI...` autocomplete it (version number)*
	* *Install Guest module via `sh VBoxLinuxAdditions.run`*
* Select `Edit > Shared folders` in the VirtualBox Overview and click the `+` icon to add a new shared folder
* Mount your shared folder via `sudo mount -t vboxsf name-of-the-folder path-to-folder-on-vm`
* Set up the PGDG apt repository http://www.postgresql.org/about/news/1432/
* Add the Postgresql package repository via `sudo add-apt-repository ppa:pitti/postgresql`
* Update packagelist via `sudo apt-get udpate`
* Install the needed packages via `sudo apt-get install vim ntp curl build-essential git libcurl4-openssl-dev libmysqlclient-dev libreadline-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev libpq-dev libpq5 python-psycopg2 pgdg-keyring postgresql-9.2 postgresql-contrib-9.2`
* Install RVM via `\curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0`
 * Check the current ruby version via `ruby -v`, if it's not set to 2.1.0, try the following
  * *Use `rvm use 2.1.0`. If it's not working, you first need to install this ruby.*
  * *Use `rvm install 2.1.0` to install the ruby and `rvm use 2.1.0` to start it.*
  * *If the ruby is not available for install, follow [this guide]( http://stackoverflow.com/questions/9056008/installed-ruby-1-9-3-with-rvm-but-command-line-doesnt-show-ruby-v/9056395#9056395)*
* Create a new database user for your user with
 * `psql -U postgres` to access the prompt
 * `CREATE USER username`
* Get a database dump from Vikhyat and load it via `pg_restore -U username -d dbname dumpfile`
* Navigate to your shared folder and get a copy of Hummingbird via `git clone https://github.com/vikhyat/hummingbird.git`
* Install bundle via `bundle install` (You might need to add some dependencies, just follow the instructions it gives you)
* `bundle exec foreman start`
 * *If `redis`outputs an error while starting the bundle, navigate to `/var/log/redis` and check the log file via `tail r...` (autocomplete). It contains further instructions on how to solve the issue*
 * *If `unicorn`failed starting `postgresql` with the error `no password supplied`, edit the `/etc/postgresql/9.2/main/pg_hba.conf` and replace the `peer` / `md5` in every uncommented line with `grant`*
* You can now access your local Hummingbird copy via `localhost:3000`
 * If the page itself displays database errors, check your user's permissions
 * Alternatively just `ALTER USER yourname WITH SUPERUSER` to bypass security

* Optionally, you can add your VM as a host so you can access the site from your host system (Windows)
 * Type `ifconfig` and copy the ip from your ethernet interface (usually `eth0`)
 * Navigate to `%systemroot%\system32\drivers\etc` on windows and edit the file `hosts`
 * Add the ip you copied and the name you want to link it on a new line: `192.168.1.38 hummingbird.cb`
 * Save the file and request the url in your webbrowser to see if it works `hummingbird.cb:3000`
