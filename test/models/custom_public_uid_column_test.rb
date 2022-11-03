require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    context 'Model with custom public uid column' do
      let(:model_class) { "#{orm_module}::CustomPublicUidColumnModel".constantize }
      let(:user) { model_class.new }

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

      describe '#dup' do
        let(:user) { model_class.new(:custom_uid => 'abcdefg') }

        it do
          dup_user = user.dup
          expect(user.custom_uid).must_equal('abcdefg')
          expect(dup_user.custom_uid).must_equal(nil)
        end
      end

      describe '#clone' do
        let(:user) { model_class.new(:custom_uid => 'abcdefg') }

        it do
          clone_user = user.clone
          expect(user.custom_uid).must_equal('abcdefg')
          expect(clone_user.custom_uid).must_equal('abcdefg')
        end
      end
    end
  end
end
