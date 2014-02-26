### Setting up a development environment on OS X

* Install Homebrew: http://brew.sh/
* Install Ruby 2.1.0 using RVM: https://rvm.io/rvm/install
* Using Homebrew, install the following:
  a. git
  b. curl
  c. v8
  d. beanstalkd
  e. redis
* Install Postgres.app: http://postgresapp.com/
* Get a database dump from Vikhyat and load it into Postgres.
* (in terminal) cat ~/Downloads/dump-.... | gzip -d | /Applications/Postgres.app/Contents/MacOS/bin/psql
* cd hummingbird && bundle install
* bundle exec foreman start

## Setting up a developmen environment on Windows
This setup is using `Ubuntu` running inside `VirtualBox` on a Windows machine.


* Make sure that you have enabled the VT-x / AMD-v settings in your BIOS, otherwise VirtualBox will not boot correctly.
* Download a copy of `Ubuntu` from http://www.ubuntu.com/download/desktop


* Download and Install `VirtualBox` from http://virtualbox.org
* Open `VirtualBox` and create a new VM.
 * You can choose whatever name you want but make sure to set the `type` to `other` and the `version` to `Other/Unknown (64bit)` if you want to run a 64bit image on it, even if it is Ubuntu.
 * All other settings don't need to be changed, you can however adjust the RAM and disk size for your need.
* Start your new VM and select the `Ubuntu image` you previously downloaded and run through the setup.
* Open the VM's network settings (Machine > Settings > Network) and change the type of the adapter to `bridge`. `Ubuntu` won't download/upadte any packages otherwise.
* Navigate to `/media/VBOXADDITIONS_...`
* Install Guest module via `sh VBoxLinuxAdditions.run`
* Create a `shared` directory to mount a shared folder for the db dump and further development
* Mount your shared folder via `sudo mount -t vboxsf name-of-the-folder path-to-folder-on-vm`
* Set up the PGDG apt repository http://www.postgresql.org/about/news/1432/
* (Add the repository needed for Postgresql packages via `sudo add-apt-repository ppa:pitti/postgresql`)
* Update packagelist via `sudo apt-get udpate`
* Install the needed packages via `sudo apt-get install vim ntp build-essential git libcurl4-openssl-dev libmysqlclient-dev libreadline-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev libpq-dev libpq5 python-psycopg2 pgdg-keyring`
* Install the Postgresql packages `postgresql-9.2`, `postgresql-contrib-9.2`
* Install RVM via `\curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0`
* Get a database dump from `vikhyat` and *restore* it via `pg_restore -U username -d dbname dumpfile`
