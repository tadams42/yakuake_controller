if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'test'
  end
end

require 'yakuake_controller'
require "pry"

require File.expand_path('test/minitest_extensions.rb')
