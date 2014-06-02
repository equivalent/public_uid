require 'pathname'
require 'bundler/setup'
require 'minitest/autorun'
require 'public_uid'

class Minitest::Spec
  class << self
    alias :context :describe
  end
end

class TestConf
  class << self
    def root_path
      Pathname.new(File.expand_path '../..', __FILE__)
    end

    def orm_modules
      @orm_modules ||= []
    end

    def add_orm_module(konstant)
      orm_modules << konstant
    end
  end
end

['active_record'].each do |orm|
  begin
    load  TestConf.root_path.join 'test', 'support', 'orm', "#{orm}.rb"
  rescue LoadError
    raise "ORM #{orm} not available"
  end
end
