module ChinaRegion
  class Type
    include Comparable

    attr_reader :name, :number_count

    def initialize(name, number_count)
      @name = name
      @number_count = number_count
    end

    def <=>(other)
      other.number_count <=> number_count
    end

    def to_s
      name.to_s
    end


    class << self
      def all
        @all ||= [
          Type.new("province", 2),
          Type.new("city", 4),
          Type.new("district", 6),
          Type.new("street", 9),
          Type.new("community", 12)
        ]
      end

      %w(number_count name).each do | method_name |
        define_method "by_#{method_name}" do | param |
          all.select{| t | t.send(method_name) == param }.first
        end
      end

      def by_code(code)
        by_number_count(code.size)
      end
    end
  end
end
