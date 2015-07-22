
require 'open3'

module Rerake
  # Parse stdout and stderr from a command run via `Open3.capture3`.
  class CommandOutput
    # Internal methods that neither depend on nor affect instance state.
    module Internals
      def self.run_command(cmd_line)
        Open3.capture3 cmd_line
      end

      def self.split_lines(buffer)
        buffer.split "\n"
      end
    end
    private_constant :Internals

    attr_reader :errors, :output, :status

    def initialize(cmd_line)
      output, errors, status = Internals.run_command cmd_line
      parse_results_from output, errors, status
    end

    private

    def parse_results_from(output, errors, status)
      @output = Internals.split_lines output
      @errors = Internals.split_lines errors
      @status = status
      self
    end
  end # class Rerake::CommandOutput
end
