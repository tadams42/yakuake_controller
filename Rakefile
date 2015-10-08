# require 'rubygems'
require "bundler/gem_tasks"
require 'bundler/setup'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

# load rakefile extensions (tasks)
Dir['tasks/*.rake'].sort.each { |f| load f }

task :default => [:test]
