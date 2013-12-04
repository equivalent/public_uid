module PublicUid
  class SetPublicUid
    attr_reader :new_uid

    def initialize(options)
      @record  = options[:record] || raise(NoRecordSpecified)
      @column  = options[:column] || raise(NoPublicUidColumnSpecified)
      @klass   = @record.class
      @new_uid = nil
      check_column_existance
    end

    def generate(generator)
      begin
        @new_uid= generator.generate
      end while similar_uid_exist?
    end

    def set
      @record.send("#{@column}=", @new_uid || raise(NewUidNotSetYet))
    end
    private

    def similar_uid_exist?
      @klass.where(public_uid: @new_uid).count > 0
    end

    def check_column_existance
      raise PublicUidColumnDoesNotExist if @klass.column_names.include?(@column)
    end

    class NewUidNotSetYet < StandardError; end
    class PublicUidColumnDoesNotExist < StandardError; end
    class NoPublicUidColumnSpecified  < StandardError; end
    class NoRecordSpecified           < StandardError; end
  end
end
