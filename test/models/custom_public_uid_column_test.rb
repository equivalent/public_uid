require 'test_helper'

class CustomPublicUidColumnModel < ActiveRecord::Base
  self.table_name = "users"
  include PublicUid
  generate_public_uid column: :custom_uid
end

describe 'CustomPublicUidColumnModel' do
  let(:user){CustomPublicUidColumnModel.new}

  describe '#custom_uid' do
    subject{ user.custom_uid }

    context 'in new record' do
      it{ subject.must_be_nil }
    end

    context 'after save' do
      before do
        user.save
        user.reload
      end
      it{ subject.wont_be_nil }
      it 'by default should generate 7 digit number string' do
        subject.to_i.to_s.length.must_equal(7)
      end
    end
  end
end
