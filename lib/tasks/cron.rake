task :cron => :environment do
  `rake db:rank:all`
end