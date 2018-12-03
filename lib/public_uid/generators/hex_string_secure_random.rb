require 'securerandom'

module PublicUid
  module Generators
    class HexStringSecureRandom
      def initialize(length=8)
        @length = length
      end

      def generate
        if @length.odd?
          result = SecureRandom.hex( (@length+1)/2 )  #because in "SecureRandom.hex(@length)" @length means length in bytes = 2 hexadecimal characters  
          return result[0...-1]
        else
         SecureRandom.hex(@length/2)
        end
      end
    end
  end
end
