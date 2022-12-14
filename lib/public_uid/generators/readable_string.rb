# frozen_string_literal: true

require 'nanoid'

module PublicUid
  module Generators
    class ReadableString
      NUMBERS = [*'0'..'9'].freeze
      UPPERCASE = [*'A'..'Z'].freeze
      LOOKALIKES = %w[0 1 i I l O o].freeze

      CHARS = (NUMBERS + UPPERCASE).freeze
      DEFAULT_ALPHABET = (CHARS - LOOKALIKES).join.freeze

      attr_reader :prefix, :length, :alphabet, :block

      def initialize(prefix: '', length: 10, alphabet: DEFAULT_ALPHABET, &block)
        @prefix = prefix
        @length = length
        @alphabet = alphabet
        @block = block
      end

      def generate(record:)
        [prefix, block&.call(record), random_string].compact.join.upcase
      end

      private

      def random_string
        Nanoid.generate(size: length, alphabet:)
      end
    end
  end
end
