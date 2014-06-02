require 'orm_adapter/adapters/active_record'
ActiveRecord::Base.send(:include, PublicUid::Model)
