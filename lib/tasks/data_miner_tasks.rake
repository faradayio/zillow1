  namespace :data_miner do
    task :run => :environment do
      resource_names = %w{R RESOURCES RESOURCE RESOURCE_NAMES}.map { |possible_key| ENV[possible_key].to_s }.join.split(/\s*,\s*/).flatten.compact
      DataMiner.run :resource_names => resource_names
    end
  end

