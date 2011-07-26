# sabshere 2/21/11 see config/environment.rb for Rails.cache setup

CacheMethod.config.storage = Rails.cache # Dalli::Client.new
CacheMethod.config.default_ttl = 180_000 # 50 hours
