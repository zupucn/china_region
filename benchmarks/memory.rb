require 'benchmark'
require "china_region"

ChinaRegion.config.orm = :memory
ChinaRegion::Region.init_db
cs = ChinaRegion::Region.get('43')
street = cs.children.first.children.first
Benchmark.bmbm(1000) do |t|
  t.report(:children) do
    cs.children
  end
  t.report(:districts) do
    cs.districts
  end
  t.report(:streets) do
    cs.streets
  end
  t.report(:communities) do
    cs.communities
  end
  t.report(:street_commuities) do
    street.communities
  end
end