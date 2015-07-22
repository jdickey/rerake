
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rerake'

require 'simplecov'
require 'minitest/autorun'
# FIXME: Tools?
# require 'codeclimate-test-reporter'
# require 'coveralls'

SimpleCov.start do
  add_filter '/vendor/'
  formatter SimpleCov::Formatter::MultiFormatter[
    # CodeClimate::TestReporter::Formatter,
    # Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter
  ]
end
# FIXME: Uncomment this once Coveralls is properly set up. Including it before
#        then *prevents coverage reports from being generated.*
# Coveralls.wear!

require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(
  color: true, detailed_skip: true, fast_fail: true)
                         ]
