# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Zillow1::Application.load_tasks

namespace :memcache do
  task :flush => :environment do
    Rails.cache.clear
  end
end
