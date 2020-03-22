module PublicUid
  module ModelConcern
    RecordNotFound = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      generate_public_uid
    end

    class_methods do
      def find_puid!(public_uid)
        find_by!(public_uid: public_uid)
      rescue ActiveRecord::RecordNotFound
        raise PublicUid::RecordNotFound, "#{self.name} '#{public_uid}' not found"
      end

      def find_puid(public_uid)
        find_puid!(public_uid)
      rescue PublicUid::RecordNotFound
        nil
      end
    end

    def to_param
      public_uid
    end
  end
end
