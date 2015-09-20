
require "rerake/version"

require 'rerake/command_output'

# Main containing module for Rerake, a Rake output-parsing and -reporting tool.
module Rerake
  def self.call
    # print 'Running Rake...'
    cmdline = ENV['RERAKE_COMMAND'] || 'bundle exec rake'
    cmd = CommandOutput.new cmdline
    # output_lines = cmd.output
    # puts 'done.'
    # puts "Parsers would do their thing here."
    cmd
  end
end
