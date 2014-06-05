module PublicUid
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    def generate_uid
      pub_uid = SetPublicUid.new(record: self, column: self.class.public_uid_column)
      pub_uid.generate self.class.public_uid_generator
      pub_uid.set
    end

    module ClassMethods
      attr_reader :public_uid_column
      attr_reader :public_uid_generator

      def generate_public_uid(options={})
        @public_uid_column    = options[:column]    || :public_uid
        @public_uid_generator = options[:generator] || Generators::RangeString.new
        before_create :generate_uid, unless: @public_uid_column
      end
    end
  end
end
