server: cd server && bin/bundle exec puma --port 3000 --environment development
worker: cd server && bin/bundle exec sidekiq -q default -q mailer -q paperclip
client: cd client && ember server --port 4200 --environment development
