# ChinaRegion [![CircleCI](https://circleci.com/gh/zupucn/china_region.svg?style=shield)](https://circleci.com/gh/zupucn/china_region) [![Code Climate](https://codeclimate.com/github/zupucn/china_region/badges/gpa.svg)](https://codeclimate.com/github/zupucn/china_region) [![Test Coverage](https://codeclimate.com/github/zupucn/china_region/badges/coverage.svg)](https://codeclimate.com/github/zupucn/china_region/coverage)

中国的城市数据包,包含省份、城市、地区、街道、社区。数据来自中华人名共和国国家统计局 [http://www.stats.gov.cn/](http://www.stats.gov.cn/)，数据条目数：657,598。目前支持 Redis 与 ActvieRecord 数据存储。此 Gem 不包含 UI 实现，仅提供数据。
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'china_region', github: "zupucn/china_region"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install china_region

## Database setup
By default china_region uses Active Record. If you want to use Redis as your backend, create an initializer file in your Rails application with the corresponding code inside:
### Redis
```ruby
# config/initializers/china_region.rb
ChinaRegion::Config.set do
  orm :redis
  redis Redis.new(:host => "10.0.1.1", :port => 6380, :db => 15)
end
```
### ActiveRecord
```ruby
rails g china_region:migration
rails db:migrate
```
### Import data
```ruby
rails china_region:seed
```
NOTE: 根据数据库的不同执行时间将有所差异，请**不要**中途终止导入命令
## Usage

```ruby
ChinaRegion::Region.provinces # 获取所有省份, 类似的接口还有 cities、districts、streets、communities

ChinaRegion::Region.cities_of("43") # or ChinaRegion::Region.get("430000") 获取 湖南省的所有城市

ChinaRegion::Region.streets_of("43") # 获取湖南省的所有街道, 跨级获取， 这里不会返回城市数据与区域数据
# 类似的接口还有 districts_of、 communities_of

region = ChinaRegion::Region.get("430100") # or ChinaRegion::Region.get("43010")  ChinaRegion::Region.get("4310") 获取长沙市、当然你给的如果是省级代码则返回省
# => return instance of ChinaRegion::Region  
region.code
# => "4310"
region.name
# => "长沙"
parent = region.parent

parent.code
# => "43"
parent.name
# => "湖南"
region.children    # 返回该行政级别的下一级别的所有区域

region.districts   # 获取长沙市的所有区域、比如 芙蓉区、雨花区...

region.streets     # 获取长沙市的所有街道

region.communities # 获取长沙市所有社区
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zupucn/china_region. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
