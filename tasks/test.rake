require 'rake/testtask'

ALL_TEST_FILES = FileList[
    'test/{functional,unit,yakuake_controller,lib,ext}/**/*_test.rb',
    'test/*_test.rb'
  ]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = ALL_TEST_FILES
  t.verbose = false
  t.warning = false
end

namespace :test do

  desc 'Run all tests and calculate code coverage'
  task :simplecov do
    ENV['COVERAGE'] = "true"
    Rake::Task['test'].execute
  end

  desc 'Run single test: "rake test:single[foo_test_method]"'
  task :single, [:test_file] do |t, args|
    filename = File.basename(args[:test_file])
    filepath = ALL_TEST_FILES[ ALL_TEST_FILES.find_index{|f| /.*#{filename}.*/ === f } ]
    ENV["TEST"] = filepath
    Rake::Task[:test].execute
  end

end
