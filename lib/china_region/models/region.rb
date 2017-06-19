module ChinaRegion
  # Main model, stores all information about what happened
  class Region < inherit_orm("Region")
    include Query

    def type
      @type ||= Match.type_of(code)
    end
    # 获取父级行政区的 code
    def parent_code
      compacted = Match.compact(Match.split(code))
      compacted.take(compacted.size - 1).join
    end

    def parent
      @parent ||= self.class.get parent_code
    end

    def children
      children_type = Type.all[Type.all.index(self.type)+1]
      return [] unless children_type
      send(children_type.name.pluralize)
    end
    # 补全 code
    # example:
    #  11 => 110000
    def full_code
      code.ljust(6, '0')
    end

    def ==(other)
      code == other.code
    end
  end
end
