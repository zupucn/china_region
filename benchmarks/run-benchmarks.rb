#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))


require 'china_region'
require 'benchmark'
require 'redis'
class ChinaRegionBenchmarks

  def run
    ChinaRegion.config.orm = (ENV['CR_ORM'] || :active_record).to_sym
    case ChinaRegion.config.orm
    when :active_record
      require 'active_record'
      require 'active_record/connection_adapters/sqlite3_adapter'

      ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
      ActiveRecord::Migrator.migrate(File.expand_path('../../spec/migrations', __FILE__))
    when :redis
      require 'redis'
      ChinaRegion.config.redis = Redis.new(:url => ENV['CR_REDIS_URL'])
    end

#    ChinaRegion.config.orm = :redis
#    ChinaRegion.config.redis = ChinaRegion.config.redis = Redis.new(:url => ENV['CR_REDIS_URL'])
    ChinaRegion::Region.init_db
    region = ChinaRegion::Region.get("43")
    Benchmark.bmbm(1000) do |x|
      x.report(:children){ region.children.to_a }
      x.report(:cities){ region.cities.to_a  }
      x.report(:districts){ region.districts.to_a  }
      x.report(:streets){ region.streets.to_a  }
      x.report(:communities){ region.communities.to_a  }
      x.report(:regions_of_province){ ChinaRegion::Region.regions_of("43").to_a  }
      x.report(:regions_of_city){ ChinaRegion::Region.regions_of("4301").to_a  }
      x.report(:regions_of_district){ ChinaRegion::Region.regions_of("430102").to_a  }
      x.report(:regions_of_street){ ChinaRegion::Region.regions_of("430102001").to_a  }
      x.report(:class_method_provinces){ ChinaRegion::Region.provinces.to_a  }
      x.report(:class_method_cities){ ChinaRegion::Region.cities.to_a  }
      x.report(:class_method_streets){ ChinaRegion::Region.streets.to_a  }
#      x.report(:communities){ ChinaRegion::Region.communities }
    end
  end
end


ChinaRegionBenchmarks.new.run
