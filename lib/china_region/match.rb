module ChinaRegion
  module Match
    extend self

    CODE_RULE_REGEX = /^(\d{2})(\d{2}|\d{0}$)(\d{2}|\d{0}$)(\d{3}|\d{0}$)(\d{3}|\d{0})$/

    def upper_level(code)
      compacted = compact(split(code))
      compacted.take(compacted.size - 1).join
    end

    def match?(code)
      !!(code =~ CODE_RULE_REGEX)
    end

    def split(code)
      return [] unless match?(code)
      code.match(CODE_RULE_REGEX).captures.reject { |c| c.size.zero?}
    end

    def compact(splited_code_array)
      while(!!splited_code_array.last && splited_code_array.last.to_i.zero?)
        splited_code_array.pop
      end
      splited_code_array
    end

    # 除去了补全 0 的 code
    # example:
    #   430000 => 43
    #   431000 => 4310
    def short_code(code)
      code
  #    compact(split(code)).join
    end

    def type_of(code)
      ChinaRegion::Type.by_number_count(code.size)
    end
  end
end
