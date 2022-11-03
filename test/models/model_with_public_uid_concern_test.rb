require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    context 'Model with default generator' do
      let(:model_class) { "#{orm_module}::ModelWithPublicUidConcern".constantize }
      let(:user) { model_class.new }

      describe '#public_uid' do
        subject{ user.public_uid }

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

          it{ expect(user.to_param).must_equal(subject) }
          it{ expect(model_class.find_puid(subject)).must_equal(user) }
          it{ expect(model_class.find_puid!(subject)).must_equal(user) }


          it{ expect(model_class.find_puid('nonexisting')).must_be_nil }
          it do
            assert_raises PublicUid::RecordNotFound do
              model_class.find_puid!('nonexisting')
            end
          end
        end
      end

      describe '#dup' do
        let(:user) { model_class.new(:public_uid => 'abcdefg') }

        it do
          dup_user = user.dup
          expect(user.public_uid).must_equal('abcdefg')
          expect(dup_user.public_uid).must_equal(nil)
        end
      end

      describe '#clone' do
        let(:user) { model_class.new(:public_uid => 'abcdefg') }

        it do
          clone_user = user.clone
          expect(user.public_uid).must_equal('abcdefg')
          expect(clone_user.public_uid).must_equal('abcdefg')
        end
      end
    end
  end
end
