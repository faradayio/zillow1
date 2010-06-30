# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# http://docs.heroku.com/cron
# sabshere 6/30/10 i'm gonna sign us up for daily cron
task :cron => :environment do
  StatisticalArea.fetch_and_store_listings!
end
