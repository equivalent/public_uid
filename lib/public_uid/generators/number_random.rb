# frozen_string_literal: true

module PublicUid
  module Generators
    class NumberRandom
      def initialize(scale = 1_000_000..9_999_999)
        @scale = scale
      end

      def generate(record: nil, randomizer: Random.new)
        randomizer.rand(@scale)
      end
    end
  end
end
