require 'rake'

namespace :public_uid do
  desc "Generate public_uid on Models that have public_uid column on records that have nil value"
  task :generate => :environment do
    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |model|
      model.connection # establish conection

      if model.instance_methods.collect(&:to_s).include?('generate_uid')
        puts "Model #{model.name}:"
        uid_column_name = model.public_uid_column
        model
          .where(uid_column_name => nil)
          .tap { |scope| puts "  * generating #{scope.count} #{uid_column_name}(s) for #{model.table_name}" }
          .find_each do |record_without_public_uid|
          record_without_public_uid.generate_uid
          record_without_public_uid.save!
        end
        puts ''
      end
    end
  end
end
