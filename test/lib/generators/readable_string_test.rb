# frozen_string_literal: true

require 'test_helper'

describe 'ReadableString' do
  describe '#generate' do
    let(:record) { nil }
    subject { instance.generate(record:) }

    context 'by default' do
      let(:instance) { PublicUid::Generators::ReadableString.new }
      it 'generates 10 chars string' do
        expect(subject.length).must_equal 10
        expect(subject).must_be_kind_of String
      end

      it 'generates upcased chars' do
        expect(subject).must_match(/^[0-9A-Z]*$/)
      end
    end

    context 'with args' do
      let(:record) { 'WORLD' }

      let(:instance) do
        PublicUid::Generators::ReadableString.new(prefix: 'TEST-', length: 3) do |record|
          "HELLO-#{record.to_s.upcase}--"
        end
      end

      it 'generates a string with the prefix' do
        expect(subject).must_match(/^TEST-/)
      end

      it 'generates a with the result of calling the block with the record' do
        expect(subject).must_match(/HELLO-WORLD/)
      end

      it 'generates a random suffix of length 3' do
        expect(subject).must_match(/^TEST-HELLO-WORLD--[0-9A-Z]{3}$/)
      end
    end
  end
end
