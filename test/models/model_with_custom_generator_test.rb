require 'test_helper'

class ModelWithCustomGererator < ActiveRecord::Base
  self.table_name = "users"
  include PublicUid

  gener_range = ('a'..'z').to_a+('A'..'Z').to_a

  generate_public_uid generator: PublicUid::Generators::RangeString.
                                   new(10, gener_range)
end

describe 'ModelWithCustomGererator' do
  let(:user){ModelWithCustomGererator.new}

  describe '#public_uid' do
    subject{ user.public_uid }

    context 'in new record' do
      it{ subject.must_be_nil }
    end

    context 'after save' do
      before do
        user.save
        user.reload
      end

      it 'should generate 10 chars' do
        subject.must_be_kind_of String
        subject.length.must_equal(10)
      end

      it 'string including up & down case' do
        subject.must_match(/^[a-zA-Z]+$/)
      end

    end
  end
end
