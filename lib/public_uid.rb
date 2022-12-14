# frozen_string_literal: true

require 'active_record'
require 'public_uid/version'
require 'public_uid/set_public_uid'
require 'public_uid/model'
require 'public_uid/generators/number_random'
require 'public_uid/generators/range_string'
require 'public_uid/generators/number_secure_random'
require 'public_uid/generators/hex_string_secure_random'
require 'public_uid/generators/readable_string'
require 'public_uid/model_concern'
require 'public_uid/tasks' if defined?(Rails)

module PublicUid
  RecordNotFound = Class.new(StandardError)
end

ActiveRecord::Base.include PublicUid::Model
