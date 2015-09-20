
require_relative 'mini_test/counts'
require_relative 'mini_test/matcher'

module Rerake
  module Parser
    # Parses MiniTest (Spec/Unit) output, storing reported count values.
    class MiniTest
      # Internal methods that neither affect nor depend on instance state.
      module Internals
        def self.captures_as_ints(captures)
          captures.map(&:to_i)
        end

        def self.first_match_from_lines(report_lines, regexp)
          Array(report_lines).grep(regexp).first
        end
      end
      private_constant :Internals

      attr_reader :counts

      def initialize(report_lines)
        @report_lines = report_lines
        @counts = Counts.new Matcher.indexes
        self
      end

      def parse
        return self unless detail_line
        @counts.assign_from values
        self
      end

      private

      attr_reader :report_lines

      def detail_line
        @detail_line ||= Internals.first_match_from_lines report_lines, matcher
      end

      def matcher
        @matcher ||= Matcher.new.to_regexp
      end

      def match_data
        detail_line.match matcher
      end

      def values
        Internals.captures_as_ints match_data.captures
      end
    end # class Rerake::Parser::MiniTest
  end
end
