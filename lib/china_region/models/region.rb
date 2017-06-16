module ChinaRegion
  # Main model, stores all information about what happened
  class Region < inherit_orm("Region")
    include Query

    def type
      @type ||= Match.type_of(short_code)
    end
    # 获取父级行政区的 code
    def parent_code
      compacted = Match.compact(Match.split(code))
      compacted.take(compacted.size - 1).join.ljust(6,'0')
    end
    # 补全 code 到 12 位
    # example:
    #  110000 => 110000000000
    def full_code
      code.ljust(12,'0')
    end
    # 除去了补全 0 的 code
    # example:
    #   430000 => 43
    #   431000 => 4310
    def short_code
      Match.compact(Match.split(code)).join
    end
  end
end
