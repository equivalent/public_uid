namespace :public_uid do
  desc "Generate public_uid on Models that have public_uid column on records that have nil public_uid"
  task :generate => :environment do
    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |model|
      model.connection # establis conection

      if model.instance_methods.collect(&:to_s).include?('generate_uid')
        puts "Model #{model.name}: generating public_uids for missing records"

        model
          .where(public_uid: nil)
          .tap { |scope| puts "  * generating #{scope.count} public_uid(s)" }
          .each do |record_without_public_uid|
            record_without_public_uid.generate_uid
            record_without_public_uid.save!
          end
        puts ''
      end
    end
  end
end
