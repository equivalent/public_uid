require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    describe 'ModelWithGeneratorDefaults' do
      let(:user) { "#{orm_module}::ModelWithGeneratorDefaults".constantize.new }

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
          it{ subject.wont_be_nil }
          it 'by default should generate 7 digit number string' do
            subject.to_i.to_s.length.must_equal(7)
          end
        end
      end
    end
  end
end
