require 'test_helper'

describe 'HexStringSecureRandom' do

  describe "#generate" do
    subject{ instance.generate }

    context 'by default' do
      let(:instance){ PublicUid::Generators::HexStringSecureRandom.new }
      it 'generates 8 chars hexa string' do
        subject.length.must_equal 8
        subject.must_be_kind_of String
      end

      it 'generates hexadecimal chars' do
        subject.must_match(/^[a-f0-9]*$/)
      end
    end

    context 'when 10 hexa chars' do
      let(:instance){ PublicUid::Generators::HexStringSecureRandom.new(10) }
      it 'generates 10 chars string' do
        subject.length.must_equal 10
      end
    end

    context 'when 11 hexa chars' do
      let(:instance){ PublicUid::Generators::HexStringSecureRandom.new(11) }
      it 'generates 11 chars string' do
        subject.length.must_equal 11
      end
    end
  end
end
