#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))


require 'china_region'
require 'benchmark'
require 'redis'
class ChinaRegionBenchmarks
  def run
    redis
  end

  def redis
    ChinaRegion.config.orm = :redis
    ChinaRegion.config.redis = ChinaRegion.config.redis = Redis.new(:url => ENV['CR_REDIS_URL'])
    ChinaRegion::Region.init_db
    region = ChinaRegion::Region.get("43")
    Benchmark.bm do |x|
      x.report(:children){ region.children }
      x.report(:cities){ region.cities }
      x.report(:streets){ region.streets }
      x.report(:communities){ region.communities }
    end
  end
end


ChinaRegionBenchmarks.new.run
