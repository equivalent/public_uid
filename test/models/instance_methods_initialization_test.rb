require 'test_helper'

TestConf.orm_modules.each do |orm_module|
  describe orm_module.description do
    context "model doesn't want to generate public_uid" do

      let(:model) do
        "#{orm_module}::ModelWithoutGenaratePublicUid".constantize
      end

      it 'model should not expose :generate_uid public instance method' do
        model.instance_methods.wont_include :generate_uid
      end
    end

    context "model wants to generate public_uid" do
      let(:model) do
        "#{orm_module}::ModelWithGeneratorDefaults".constantize
      end

      it 'model should expose :generate_uid public instance method' do
        model.instance_methods.must_include :generate_uid
      end
    end
  end
end
