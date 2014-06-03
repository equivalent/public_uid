class TestConf
  class << self
    def supported_orms
      %w(active_record)
    end

    def orm_modules
      @orm_modules ||= []
    end

    def add_orm_module(konstant)
      orm_modules << konstant
    end
  end
end
