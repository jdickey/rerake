
require "rerake/version"

require 'rerake/command_output'

# Main containing module for Rerake, a Rake output-parsing and -reporting tool.
module Rerake
  def self.call
    print 'Running Rake...'
    puts 'done.'
    puts "Parsers would do their thing here."
  end
end
