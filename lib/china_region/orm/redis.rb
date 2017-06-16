require 'redis'
require "active_support/core_ext"
require_relative 'redis/region.rb'

unless ChinaRegion::ORM::Redis::Region.db_exists?
  ChinaRegion::ORM::Redis::Region.init_db
end
