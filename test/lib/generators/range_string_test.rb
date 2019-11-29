require 'test_helper'

describe 'RangeString' do

  describe "#generate" do
    subject{ instance.generate }

    context 'by default' do
      let(:instance){ PublicUid::Generators::RangeString.new }
      it 'generates 8 chars string' do
        expect(subject.length).must_equal 8
        expect(subject).must_be_kind_of String
      end

      it 'generates downcase chars' do
        expect(subject).must_match(/^[a-z]*$/)
      end
    end

    context 'when 10 chars x-y' do
      let(:instance){ PublicUid::Generators::RangeString.new(3, ('x'..'z')) }
      it 'generates 10 chars string' do
        expect(subject.length).must_equal 3
      end

      it 'generates string containing chars x,y,z' do
        expect(subject).must_match(/^[x-z]*$/)
      end
    end
  end
end
