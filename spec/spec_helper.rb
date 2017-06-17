$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "database_cleaner"
require 'simplecov'
SimpleCov.start
require "china_region"

ChinaRegion.config.orm = (ENV['CR_ORM'].to_sym || :active_record)
case ChinaRegion.config.orm
when :active_record
  require 'active_record'
  require 'active_record/connection_adapters/sqlite3_adapter'

  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  ActiveRecord::Migrator.migrate(File.expand_path('../migrations', __FILE__))
when :redis
  require 'redis'
  ChinaRegion.config.redis = Redis.new(:url => ENV['CR_REDIS_URL'])
  DatabaseCleaner[:redis, {:connection => ENV['CR_REDIS_URL']} ]
end

RSpec.configure do |config|
  config.before do
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end
end
