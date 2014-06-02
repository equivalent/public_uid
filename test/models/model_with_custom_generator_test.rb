require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    describe 'ModelWithCustomGererator' do
      let(:user) { "#{orm_module}::ModelWithCustomGererator".constantize.new }

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
  end
end
