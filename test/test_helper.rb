require 'pathname'
require 'bundler/setup'
require 'minitest/autorun'

class Minitest::Spec
  class << self
    alias :context :describe
  end
end

ROOT_PATH = Pathname.new(File.expand_path '../..', __FILE__) 
require  ROOT_PATH.join 'test', 'support', 'test_conf'

TestConf.supported_orms.each do |orm|
  require orm
end

require 'public_uid'

TestConf.supported_orms.each do |orm|
  load  ROOT_PATH.join 'test', 'support', 'orm', "#{orm}.rb"
end
