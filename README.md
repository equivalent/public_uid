# PublicUid

[![Build Status](https://travis-ci.org/equivalent/public_uid.svg?branch=master)](https://travis-ci.org/equivalent/public_uid)
[![Code Climate](https://codeclimate.com/github/equivalent/public_uid.png)](https://codeclimate.com/github/equivalent/public_uid)


Generates random string (or random number) to represent public unique
record identifier.

### `public_uid` vs `record.id`

Let say you're building social network or business dashboard.

If you publicly display your *record ids* as an unique identificator for
accessing your records (as a part of HTML url or in JSON) it's easy to
 estimate how many records (users, clients, messages, orders,...) you have
in the database. Marketing of rival companies may use this information
against you.

This is bad: 

    http://www.eq8.eu/orders/12/edit
    http://www.eq8.eu/orders/12-order-for-mouse-and-keyboard/edit

However if you generate random unique identifier and use that as a public
identifier, you won't have to worry about that.

This is how it should be: 

    http://www.eq8.eu/orders/8395820/edit
    http://www.eq8.eu/orders/8395820-order-for-mouse-and-keyboard/edit
    http://www.eq8.eu/orders/abaoeule/edit
    http://www.eq8.eu/orders/aZc3/edit

So keep `record.id` for your internal relationships and show `public_id`
to the world :smile:

## Installation

Add this line to your application's Gemfile:

    gem 'public_uid'

And then execute:

    $ bundle


## Usage


### Step 1 - db column

Create database column for public unique ID.

```ruby
class AddPublicUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_uid, :string
    add_index  :users, :public_uid, unique: true
  end
end
```

or if you are creating table

```ruby
class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      # ...
      t.string :public_uid, index: { unique: true }
      # ...
    end
  end
end
```

### Step 2a - Using Rails concern

> a.k.a - the easy way for Rails (availible since version 2.1.0)

```ruby
class User < ActiveRecord::Base
  include PublicUid::ModelConcern
end
```

Example:


```ruby
user = User.create
user.public_uid
# => "xxxxxxxx"

user.to_param
# => "xxxxxxxx"

User.find_puid('xxxxxxxx')
# => <#User ...>
User.find_puid('not_existing')
# => nil

User.find_puid!('xxxxxxxx')
# => <#User ...>
User.find_puid!('not_existing')
# PublicUid::RecordNotFound (User 'not_existing' not found)
```

This will automatically:

* assumes your model has `public_uid` column and generate public_uid value for you
* will automatically tell model to use `public_uid` as `to_param` method   ffectively turning `user.public_uid` the attribute passed in routes when you do routes (instead of `id`). Example `user_path(@user)` => `/users/xxxxxxx` 
* provides `User.find_puid('xxxxxx')` and `User.find_puid!('xxxxxx')` class methods as more convenient replacement for `find_by!(public_uid: 'xxxxxxx')` to find records in controllers.
* `User.find_puid!('xxxxxx')` will raise `PublicUid::RecordNotFound`   instead of `ActiveRecord::RecordNotFound` for more accurate error handling in Rails controller (check [Rails rescue_from](https://apidock.com/rails/ActiveSupport/Rescuable/ClassMethods/rescue_from) for inspiration)

> more info check > [source](https://github.com/equivalent/public_uid/blob/master/lib/public_uid/model_concern.rb)

If you need more customization please  follow **Step 2b** instead

### Step 2b - Using manual generate method

> a.k.a bit harder than `2.a` but more flexible way for Rails

Tell your model to generate the public identifier

```ruby
class User < ActiveRecord::Base
  generate_public_uid
end
```

This will automatically generate unique 8 char downcase string for 
column `public_uid`. 


```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> "aeuhsthi"
```

Then you can do more clever things like having urls based on `public_uid` and `title` (http://blog.teamtreehouse.com/creating-vanity-urls-in-rails)

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  generate_public_uid

  def self.find_puid(param)
    find_by! public_uid: param.split('-').first
  end
  
  def to_param
    "#{public_uid}-#{tile.gsub(/\s/,'-')}"
  end
end
 
# app/controllers/users_controller.rb
class UsersController < ActionController::Base
  # ...
  def show
    @user = User.find_puid(param[:id])
    # ...
  end
  # ...
end
```


If you want to use different column just specify column option:

```ruby
class User < ActiveRecord::Base
  generate_public_uid column: :guid
end
```

```irb
u = User.new
u.guid  #=> nil
u.save! #=> true
u.guid  #=> "troxuroh"
```

If you want to generate random Integer you can use built-in number 
generator:

```ruby
class User < ActiveRecord::Base
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 4567123
```

**Note** Warning **PostgreSQL** have built in type safety meaning that this
generator wont work if your public uniq ID column is a String (as the
gem would try to set Integer on a String). If you really want a number
like string you can specify number range for Range String Generator

If you want to generate random Integer using SecureRandom ruby library you can use built-in number secure generator:

```ruby
class User < ActiveRecord::Base
  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 4567123
```

If you want to generate random Hexadecimal String using SecureRandom ruby library you can use built-in hexadecimal string secure generator:

```ruby
class User < ActiveRecord::Base
  generate_public_uid generator: PublicUid::Generators::HexStringSecureRandom.new
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 0b30ffbc7de3b362
```

### Customizing generated string

```ruby
class User < ActiveRecord::Base
  UID_RANGE = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  generate_public_uid generator: PublicUid::Generators::RangeString.new(4, UID_RANGE)
end
```

or in case you are using SecureRandom ruby library: 

```ruby
class User < ActiveRecord::Base
  generate_public_uid generator: PublicUid::Generators::HexStringSecureRandom.new(4)  #4 is length of hexadecimal string. If this argument is not set, length of hexadecimal string will be 8 characters. 
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> "aZ3e"
```

To generate number format String you can specify number range 

```
class User < ActiveRecord::Base
  UID_RANGE = ('1'..'9').to_a
  generate_public_uid generator: PublicUid::Generators::RangeString.new(4, UID_RANGE)
end

# User.create.public_uid  == "1234"
```

### Customizing randomized number 

```ruby
class User < ActiveRecord::Base
  UID_RANGE = 1_000..4_000
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new(UID_RANGE)
end
```

or in case you are using SecureRandom ruby library: 
```ruby
class User < ActiveRecord::Base
  UID_RANGE = 1_000..4_000
  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new(UID_RANGE)
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 2398
```

### Rails rake task

By using this gem you will automatically gain rake task `rake public_uid:generate`
in your Rails application which will generate `public_uid` on the tables
using `public_uid` on records where `public_uid == nil`.

This is helpfull to generate `public_uid` on pre-existing recrods.

```
rake public_uid:generate

Model EntityApplication: generating public_uids for missing records
  * generating 0 public_uid(s)

Model ValidationFormField: generating public_uids for missing records
  * generating 133 public_uid(s)

Model ValidationType: generating public_uids for missing records
  * generating 0 public_uid(s)
```

## Alternatives

There is a lot of reasons behind the existance of this gem, we are fully aware there are "built" in alternatives it's just they don't quite fit the purpouse of Developer to chose char range himself. 

Anyway if you hate our guts for writing this gem try something like:

#### UUID

```ruby
class Post < ActiveRecord::Base
 before_create :generate_random_id

 private 
 def generate_random_id
   self.id = SecureRandom.uuid
 end 
end
```

Or if you are using Rails >= 4 and PostgreSQL, you can have it generating them for you :

```ruby
create_table :posts, id: :uuid do |t|
  ...
end
```

* [Source](http://stackoverflow.com/a/34679841)

#### SecureRandom.random_number

```ruby
class MyModel < ActiveRecord::Base
  before_create :randomize_id
  
  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000)
    end while Model.where(id: self.id).exists?
  end
end

```

Or you can use `SecureRandom.hex`

In future gem version we will actually introduce this two generators.

* [Source](http://stackoverflow.com/a/13680914)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

##### 2019-11-29

Version 2.0.0 released

Till version [public_uid 1.3.1](https://github.com/equivalent/public_uid/tree/version-1.3.1) gem used [orm_adapter](https://github.com/ianwhite/orm_adapter) which mean
that you could use ActiveRecord or any other data mapping adapter (e.g. Mongoid) supported by orm adapter.

Problem is that orm_adapter is not maintained for 6 years now and cause some
gem conflicts with latest ActiveRecord development environment. That's
why I've decided to remove the ORM adapter ([commit](https://github.com/equivalent/public_uid/commit/e66b5dbf659fcdddc6b284b3eb2051a9b8a31968))
and use `ActiveRecord::Base` directly.

That means any Rails application using `public_uid` gem  ActiveRecord will **not** be affected by the 2.0 release.
If anyone want to see public_uid v 2.0 to support other data mappers (e.g. mongo) please open an issue or create PR with the fix.

Sorry for any inconvenience

