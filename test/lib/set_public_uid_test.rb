require 'test_helper'

class User < ActiveRecord::Base
  self.table_name = 'users'
end

class DummyGenerator
  def initialize
    @counter = 0
  end

  def generate
    if @counter > 1
      'second try'
    else
      'first try'
    end.tap { @counter = @counter + 1 }
  end
end

describe 'PublicUid::SetPublicUid' do
  let(:options) { {record: record, column: :public_uid} }
  let(:instance){ PublicUid::SetPublicUid.new options }

  let(:record){ User.new }

  describe 'initialization' do
    context 'when column not specified' do
      let(:options) { {record: record} }
      it{ ->{ instance }.must_raise(PublicUid::SetPublicUid::NoPublicUidColumnSpecified) }
    end

    context 'when record not specified' do
      let(:options) { {column: :foo} }
      it{ ->{ instance }.must_raise(PublicUid::SetPublicUid::NoRecordSpecified) }
    end
  end

  describe "#generate" do
    subject{ instance.new_uid }

    it "should ask generator to generate random string" do
      instance.generate(DummyGenerator.new)
      subject.must_equal 'first try'
    end

    context 'when record match random' do
      before{ User.create public_uid: 'first try' }
      after { User.destroy_all }

      it "should generate string once again" do
        instance.generate(DummyGenerator.new)
        subject.must_equal 'second try'
      end
    end
  end

  describe '#set' do
    subject{ instance.new_uid }

    context 'when @new id is not set' do
      it{ ->{ instance.set }.must_raise(PublicUid::SetPublicUid::NewUidNotSetYet) }
    end

    context 'when @new id is set' do
      before{ instance.instance_variable_set '@new_uid', '123' }

      it 'must set new_uid for record pubilc_uid column' do
        instance.set
        subject.must_equal '123'
      end
    end
  end

end
