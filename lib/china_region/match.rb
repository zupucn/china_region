module ChinaRegion
  module Match
    extend self

    CODE_RULE_REGEX = /^(\d{2})(\d{2}|\d{0}$)(\d{2}|\d{0}$)(\d{3}|\d{0}$)(\d{3}|\d{0})$/

    def match?(code)
      !!(code =~ CODE_RULE_REGEX)
    end

    def split(code)
      return [] unless match?(code)
      code.match(CODE_RULE_REGEX).captures.reject { |c| c.size.zero?}
    end

    def compact(splited_code_array)
      splited_code_array.reject{ | c | c.to_i.zero? }
    end

    # 除去了补全 0 的 code
    # example:
    #   430000 => 43
    #   431000 => 4310
    def short_code(code)
      compact(split(code)).join
    end

    def type_of(code)
      ChinaRegion::Type.by_number_count(short_code(code).size)
    end
  end
end
