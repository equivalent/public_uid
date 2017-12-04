require 'test_helper'

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

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    describe 'PublicUid::SetPublicUid' do

      let(:options)  { {record: record, column: :public_uid} }
      let(:instance) { PublicUid::SetPublicUid.new options }
      let(:record)   { record_class.new }
      let(:record_class) { "#{orm_module}::ModelWithGeneratorDefaults".constantize }

      describe 'initialization' do
        context 'when column not specified' do
          let(:options) { { record: record } }
          it{ ->{ instance } .must_raise(PublicUid::SetPublicUid::NoPublicUidColumnSpecified) }
        end

        context 'when record not specified' do
          let(:options) { {column: :foo} }
          it{ ->{ instance } .must_raise(PublicUid::SetPublicUid::NoRecordSpecified) }
        end
      end

      describe "#generate" do
        subject { instance.new_uid }

        it "should ask generator to generate random string" do
          instance.generate(DummyGenerator.new)
          subject.must_equal 'first try'
        end

        context 'when record match random' do
          before{ record_class.create public_uid: 'first try' }
          after { record_class.destroy_all }

          it "should generate string once again" do
            instance.generate(DummyGenerator.new)
            subject.must_equal 'second try'
          end
        end
      end

      describe '#set' do
        subject { instance.new_uid }

        context 'when @new id is not set' do
          it{ ->{ instance.set }.must_raise(PublicUid::SetPublicUid::NewUidNotSetYet) }
        end

        context 'when @new id is set' do
          before { instance.instance_variable_set '@new_uid', '123' }

          it 'must set new_uid for record pubilc_uid column' do
            instance.set
            subject.must_equal '123'
          end
        end
      end

      describe '#similar_uid_exist?' do
        let(:trigger) { instance.send :similar_uid_exist? }

        before { mock(instance).new_uid { 567 } }

        # There is an issue with passing integer to PostgreSQL type check
        # in previous version application deal with this issue by converting
        # everything given by generator to string which is wrong. If the output
        # of generator is not supported by DB don't use it.
        it 'must pass exact type of generator to model' do 
          count_mock = stub(record_class).count { 10 }
          stub(record_class).where( { public_uid: 567 } ) { count_mock }

          trigger.must_equal true
        end
      end
    end
  end
end
