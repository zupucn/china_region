module ChinaRegion
  module Match
    extend self

    CODE_RULE_REGEX = /^(\d{2})(\d{2})(\d{2})(\d{3}|\d{0})(\d{3}|\d{0})$/

    def match?(code)
      !!(code =~ CODE_RULE_REGEX)
    end

    def split(code)
      return [] unless match?(code)
      code.match(CODE_RULE_REGEX).captures.reject { |c| c.blank?}
    end

    def compact(splited_code_array)
      splited_code_array.reject{ | c | c.to_i.zero? }
    end

    def type_of(code)
      ChinaRegion::Type.by_number_count(code.size)
    end
  end
end
