desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  # sabshere 12/20/10 we're currently on daily cron, so don't check for hour
  StatisticalArea.fetch_and_store_listings!
end

task :clean => :environment do
  Listing.destroy_all :zpid => nil
  Appearance.destroy_all :appeared_at => nil
end
