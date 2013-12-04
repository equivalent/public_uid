module PublicUid
  module Generators
    class RangeString
      def initialize(length=8, scale='a'..'z')
        @scale  = scale
        @length = length
      end

      def generate
        @scale.to_a.shuffle[0,@length].join
      end
    end
  end
end
