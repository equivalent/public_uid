require 'orm_adapter'
require "public_uid/version"
require "public_uid/set_public_uid"
require "public_uid/model"
require "public_uid/generators/number_random"
require "public_uid/generators/range_string"

require 'public_uid/tasks' if defined?(Rails)

require 'orm/active_record' if defined?(ActiveRecord::Base)
