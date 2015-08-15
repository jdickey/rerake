
module Rerake
  module Parser
    # Parses Reek statistics reported with test output.
    class Reek
      # Internal methods not affecting or depending on instance state.
      module Internals
        def self.count_from(detail_line)
          _first_capture(detail_line.match _matcher).to_i
        end

        def self.first_match_from(report_lines)
          Array(report_lines).grep(_matcher).first
        end

        def self._first_capture(match_data)
          match_data.captures.first
        end

        def self._matcher
          /(\d+) total warning/
        end
      end
      private_constant :Internals

      attr_reader :counts

      def initialize(report_lines)
        @report_lines = report_lines
        @counts = { warnings: 0 }
        self
      end

      def parse
        return self unless detail_line
        assign_counts
        self
      end

      private

      attr_reader :report_lines

      def assign_counts
        @counts[:warnings] = Internals.count_from detail_line
      end

      def detail_line
        @detail_line ||= Internals.first_match_from(report_lines)
      end
    end # class Rerake::Parser::Reek
  end
end
