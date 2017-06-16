$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "china_region"
require "database_cleaner"
case ChinaRegion::Config.orm
when :active_record
  require 'active_record'
  require 'active_record/connection_adapters/sqlite3_adapter'

  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  ActiveRecord::Migrator.migrate(File.expand_path('../migrations', __FILE__))
end

RSpec.configure do |config|
  config.before do
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end
end
