require 'test_helper'
require 'rake'

describe 'Generate' do
  before :all do
    # load File.expand_path('../../../../lib/public_uid/tasks/generate.rake', __FILE__)
    Rake.application.rake_require 'public_uid/tasks/generate'
    Rake::Task.define_task(:environment)
  end

  TestConf.orm_modules.each do |orm_module|
    describe orm_module.description do
      {
        "#{orm_module}::ModelWithGeneratorDefaults".constantize => :public_uid,
        "#{orm_module}::ModelWithCustomGererator".constantize   => :public_uid,
        "#{orm_module}::CustomPublicUidColumnModel".constantize => :custom_uid,
      }.each_pair do |model, uid_column|

        context "For #{model.name} with #{uid_column}" do
          let(:run_generate_task) do
            Rake::Task['public_uid:generate'].reenable
            Rake.application.invoke_task 'public_uid:generate'
          end

          describe '#invoke' do
            it 'generates uid' do
              user = model.new
              user.save!
              initial_uid = user.send(uid_column)

              # simulate an existing record with no uid value
              expect(user.update_attribute(uid_column, nil)).must_equal true
              expect(user.send(uid_column)).must_be_nil

              # run the rake task
              run_generate_task

              user.reload
              expect(user.send(uid_column)).must_be_kind_of String
              expect(user.send(uid_column)).wont_be_empty
              expect(user.send(uid_column)).wont_be_same_as initial_uid
            end
          end
        end
      end
    end
  end
end
