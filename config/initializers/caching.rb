# sabshere 2/21/11 see config/environment.rb for Rails.cache setup

CacheMethod.config.storage = Rails.cache


require 'logger'
ActiveRecord::Base.logger.level = Logger::DEBUG
