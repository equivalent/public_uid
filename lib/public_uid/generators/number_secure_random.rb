require 'securerandom'

module PublicUid
  module Generators
    class NumberSecureRandom
      def initialize(scale = 1_000_000..9_999_999)
        @scale = scale
      end

      def generate()
        generated_number = SecureRandom.random_number( (@scale.max - @scale.min) )  #because SecureRandom.random_number can have only one argument = max value.
        return (generated_number + @scale.min)
      end
    end
  end
end
