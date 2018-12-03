require 'test_helper'

describe 'NumberSecureRandom' do

  describe "#generate" do
    subject{ instance.generate }

    context 'by default' do
      let(:instance){ PublicUid::Generators::NumberSecureRandom.new }
      it 'generates 7 digits' do
        subject.to_i.to_s.length.must_equal 7
        subject.must_be_kind_of Integer
      end
    end

    context 'when specifying number between 20 - 21' do
      let(:instance){ PublicUid::Generators::NumberSecureRandom.new(20..21) }
      it 'generates 2 digits' do
        subject.to_i.to_s.length.must_equal 2
        subject.must_be_kind_of Integer
      end

      it 'generates integer has to be 20 or 21' do
        [20, 21].must_include subject
      end
    end

    context 'when specifying number between 1000 - 9999' do
      let(:instance){ PublicUid::Generators::NumberSecureRandom.new(1000..9999) }
      it 'generates 4 digits' do
        subject.to_i.to_s.length.must_equal 4
        subject.must_be_kind_of Integer
      end

      it 'generates integer has to be between 1000 and 9999' do
        (1000..9999).must_include subject
      end
    end
  end
end
