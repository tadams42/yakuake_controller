require 'minitest/autorun'
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(:color => true)  # => Redgreen-capable version of standard Minitest reporter
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new     # => Turn-like output that reads like a spec

Minitest.after_run do
end
