
module Rerake
  # Contains parser classes for each supported tool; here, Reek.
  module Parser
    # Parses Reek statistics reported with test output.
    class Reek
      # Internal methods not affecting or depending on instance state.
      module Internals
        # Returns the count of total warnings from a detail line.
        #
        # The "detail line" is (assumed to be) a single line from the output of
        # running one or more Rake tasks. If the parameter does not match the
        # format of a Reek total-warning-count line, this method returns `nil`.
        #
        # @param detail_line [String] Text line, possibly matching Reek output.
        # @return [Fixnum, nil] First Regexp captured item, as integer.
        def self.count_from(detail_line)
          _first_capture(detail_line.match _matcher).to_i
        end

        # Returns the first matching line from an Array of input lines.
        #
        # If what's passed in is a *single* line, it's wrapped in an Array
        # before searching for a pattern match.
        #
        # @param report_lines [Array] Presumably, output from a `rake` command.
        # @return [String, nil] Line from input that matches matcher.
        def self.first_match_from(report_lines)
          Array(report_lines).grep(_matcher).first
        end

        # Returns first capture from Regexp match data.
        #
        # @param match_data [MatchData] object instance
        # @return [Object, nil] First capture from input data; nil if none.
        def self._first_capture(match_data)
          match_data.captures.first
        end

        # Actual Regexp instance used for matching Reek input.
        #
        # @return [Regexp] Matches total-warning line for Reek output.
        def self._matcher
          /^(\d+) total warning/
        end
      end
      private_constant :Internals

      attr_reader :counts

      # Initialises a Reek output parser. Initialises warning count to 0.
      #
      # @param report_lines [Array] Captured output from a 'rake' command.
      # @return [Parser::Reek] self
      def initialize(report_lines)
        @report_lines = report_lines
        @counts = { warnings: 0 }
        self
      end

      # Parse Reek report line in output to acquire count of detected errors.
      #
      # Leaves count unchanged (at zero) if Reek report total line not found.
      #
      # @return [Parser::Reek] self
      def parse
        return self unless detail_line
        assign_counts
        self
      end

      private

      # [Array] Input lines passed in to `#initialize`.
      attr_reader :report_lines

      # Extracts total-warning count from detail line, saving in ivar.
      #
      # @return [Parser::Reek] self
      def assign_counts
        @counts[:warnings] = Internals.count_from detail_line
        self
      end

      # Searches `report_lines` for line matching Reek summary-detail line.
      #
      # Memoises in "private" instance variable on first call.
      #
      # @return [String, nil] First Reek summary-detail line; nil if none. 
      def detail_line
        @_detail_line ||= Internals.first_match_from(report_lines)
      end
    end # class Rerake::Parser::Reek
  end
end
