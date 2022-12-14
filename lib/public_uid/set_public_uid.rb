# frozen_string_literal: true

module PublicUid
  class SetPublicUid
    NewUidNotSetYet             = Class.new(StandardError)
    PublicUidColumnDoesNotExist = Class.new(StandardError)
    NoPublicUidColumnSpecified  = Class.new(StandardError)
    NoRecordSpecified           = Class.new(StandardError)

    attr_reader :new_uid

    def initialize(options)
      @record  = options[:record] || raise(NoRecordSpecified)
      @column  = options[:column] || raise(NoPublicUidColumnSpecified)
      @klass   = @record.class
      check_column_existance
    end

    def generate(generator)
      loop do
        @new_uid = generator.generate(record: @record)
        break unless similar_uid_exist?
      end
    end

    def set
      new_uid || raise(NewUidNotSetYet)
      @record.send("#{@column}=", new_uid)
    end

    private

    def similar_uid_exist?
      @klass.where(@column => new_uid).exists?
    end

    def check_column_existance
      raise PublicUidColumnDoesNotExist if @klass.column_names.include?(@column)
    end
  end
end
