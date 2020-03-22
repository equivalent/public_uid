ActiveRecord::Base::establish_connection(adapter: 'sqlite3', database: ':memory:')
# creates 3 `users` tables, with either `public_uid` or `custom_uid` (but not both), or no uid column,
# to expose potential `SQLite3::SQLException: no such column` error.
ActiveRecord::Base.connection.execute(%{CREATE TABLE users (id INTEGER PRIMARY KEY);})
ActiveRecord::Base.connection.execute(%{CREATE TABLE user_puids (id INTEGER PRIMARY KEY, public_uid VARCHAR);})
ActiveRecord::Base.connection.execute(%{CREATE TABLE user_cuids (id INTEGER PRIMARY KEY, custom_uid VARCHAR);})

module ActRec
  def self.description
    'ActiveRecord based'
  end

  class CustomPublicUidColumnModel < ActiveRecord::Base
    self.table_name = 'user_cuids'
    generate_public_uid column: :custom_uid
  end

  class ModelWithCustomGererator < ActiveRecord::Base
    self.table_name = 'user_puids'

    gener_range = ('a'..'z').to_a+('A'..'Z').to_a

    generate_public_uid generator: PublicUid::Generators::RangeString.
                                     new(10, gener_range)
  end

  class ModelWithGeneratorDefaults < ActiveRecord::Base
    self.table_name =  'user_puids'
    generate_public_uid
  end

  require 'public_uid/model_concern'
  class ModelWithPublicUidConcern  < ActiveRecord::Base
    include PublicUid::ModelConcern
    self.table_name =  'user_puids'
    generate_public_uid
  end

  class ModelWithoutGenaratePublicUid < ActiveRecord::Base
    self.table_name =  'users'
  end
end

TestConf.add_orm_module(ActRec)
