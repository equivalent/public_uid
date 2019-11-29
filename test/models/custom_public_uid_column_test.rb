require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    context 'Model with custom public uid column' do
      let(:user) { "#{orm_module}::CustomPublicUidColumnModel".constantize.new }

      describe '#custom_uid' do
        subject{ user.custom_uid }

        context 'in new record' do
          it{ expect(subject).must_be_nil }

          describe '#generate_uid' do
            before do
              user.generate_uid
            end

            it { expect(subject).wont_be_nil }
          end
        end

        context 'after save' do

          before do
            user.save
            user.reload
          end

          it{ expect(subject).must_be_kind_of(String) }
          it{ expect(subject.length).must_equal(8) }
        end
      end
    end
  end
end
