module PublicUid
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      def generate_uid
        generate_uid! unless send(self.class.public_uid_column)
      end

      def generate_uid!
        pub_uid = SetPublicUid.new(record: self, column: self.class.public_uid_column)
        pub_uid.generate self.class.public_uid_generator
        pub_uid.set
      end
    end

    module ClassMethods
      attr_writer :public_uid_column
      attr_writer :public_uid_generator

      def generate_public_uid(options={})
        @public_uid_column    = options[:column]
        @public_uid_generator = options[:generator]

        _include_public_uid_instance_methods
        _set_callback_to_generate_public_uid
      end


      def public_uid_column
        @public_uid_column || :public_uid
      end

      def public_uid_generator
        @public_uid_generator || Generators::RangeString.new
      end

      private
      def _include_public_uid_instance_methods
        self.include PublicUid::Model::InstanceMethods
      end

      def _set_callback_to_generate_public_uid 
        self.before_create :generate_uid
      end
    end
  end
end
