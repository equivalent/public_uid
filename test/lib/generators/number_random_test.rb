require 'test_helper'

describe 'NumberRandom' do

  describe "#generate" do
    subject{ instance.generate }

    context 'by default' do
      let(:instance){ PublicUid::Generators::NumberRandom.new }
      it 'generates 7 digits' do
        subject.to_i.to_s.length.must_equal 7
        subject.must_be_kind_of Integer
      end
    end

    context 'when specifying number between 20 - 21' do
      let(:instance){ PublicUid::Generators::NumberRandom.new(20..21) }
      it 'generates 2 digits' do
        subject.to_i.to_s.length.must_equal 2
        subject.must_be_kind_of Integer
      end

      it 'generates string containing chars x,y,z' do
        [20, 21].must_include subject
      end
    end
  end
end
