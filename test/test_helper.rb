
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rerake'

require 'simplecov'
require 'minitest/autorun'
require 'codeclimate-test-reporter'
require 'coveralls'
require 'pry-byebug'

SimpleCov.start do
  add_filter '/vendor/'
  formatter SimpleCov::Formatter::MultiFormatter[
    CodeClimate::TestReporter::Formatter,
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter
  ]
end
Coveralls.wear! if ENV['COVERALLS_REPO_TOKEN']

require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(
  color: true, detailed_skip: true, fast_fail: true)
                         ]
