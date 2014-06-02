ActiveRecord::Base::establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.connection.execute(%{CREATE TABLE users  (id INTEGER PRIMARY KEY, public_uid VARCHAR, custom_uid INTEGER);})

module ActRec
  def self.description
    'ActiveRecord based'
  end

  class CustomPublicUidColumnModel < ActiveRecord::Base
    self.table_name = "users"
    generate_public_uid column: :custom_uid
  end

  class ModelWithCustomGererator < ActiveRecord::Base
    self.table_name = "users"

    gener_range = ('a'..'z').to_a+('A'..'Z').to_a

    generate_public_uid generator: PublicUid::Generators::RangeString.
                                     new(10, gener_range)
  end

  class ModelWithGeneratorDefaults < ActiveRecord::Base
    self.table_name =  "users"
    generate_public_uid
  end
end

TestConf.add_orm_module(ActRec)
