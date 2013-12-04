require 'bundler/setup'
require 'public_uid'
require 'minitest/autorun'
require 'active_record'

class Minitest::Spec
  class << self
    alias :context :describe
  end
end

ActiveRecord::Base::establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.connection.execute(%{CREATE TABLE users  (id INTEGER PRIMARY KEY, public_uid VARCHAR, custom_uid INTEGER);})

