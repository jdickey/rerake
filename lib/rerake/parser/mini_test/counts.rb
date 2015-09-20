
module Rerake
  module Parser
    # Parses MiniTest (Spec/Unit) output, storing reported count values.
    class MiniTest
      # Wraps the various counters for the MiniTest parser.
      class Counts
        # Internal methods that neither affect nor depend on instance state.
        module Internals
          # Iterates an indexed array of MatchData captures converted to ints.
          #
          # Yields the (integer) value and capture index to a block.
          #
          # @param captures [Array] Captured data from parsing text w/regexp.
          # @return [Array] Array of integer values converted from captures.
          def self.each_capture_with_index(captures)
            _as_ints(captures).each_with_index do |value, index|
              yield value, index
            end
          end

          # Returns an array of integers mapping string values passed in.
          #
          # @param captures [Array] Array of MatchData capture strings.
          # @return [Array] Result from converting @param to integers.
          def self._as_ints(captures)
            captures.map(&:to_i)
          end
        end
        private_constant :Internals

        extend Forwardable

        # Given an array of keys, creates a Struct for tagged totals.
        #
        # The only halfway tricky bit is initialising values to zero rather than
        # `nil`. This is done to guarantee that values returned will always be
        # numeric, rather than requiring a call to `#to_i` to convert.
        #
        # @param keys [Array] Array of symbols to be used as Struct keys.
        # @return [Counts] Returns this instance.
        def initialize(keys)
          @value = Struct.new(*keys).new
          @value.members.each { |key| @value[key] = 0 }
          self
        end

        # Assigns captured data (from command output) to Struct values.
        #
        # Maps integer values from (numeric-indexed) capture data to (Symbol-
        # indexed) internal Struct values. This is what will blow up if our data
        # is somehow invalid; that's a feature exposing our bug. :grinning:
        #
        # @param captures [Array] Strings matched by a regex capture somewhere.
        # @return [Counts] Returns this instance.
        def assign_from(captures)
          Internals.each_capture_with_index(captures) do |value, index|
            @value[@value.members[index]] = value
          end
          self
        end

        # Return the internal value object as a Hash instance
        #
        # Keys will be as specified to `#initialize`; values for matching keys
        # as supplied to `#assign_from`. Any unassigned values will be returned
        # as zero (see `#initialize` logic).
        #
        # @return [Hash] (Mutable) Hash with capture values (as integers).
        def to_hash
          @value.to_h
        end

        # Return a string representation of the internal value object.
        #
        # After converting to a Hash, return its string representation. This is
        # to avoid dump output like
        # `#<Rerake::Parser::MiniTest::Counts:0x007fd74e469010>`.
        #
        # @return [String] As described above.
        def to_s
          to_hash.to_h.to_s
        end

        def_delegator :to_hash, :values
        def_delegator :to_hash, :[]
      end # class Rerake::Parser::MiniTest::Counts
    end # class Rerake::Parser::MiniTest
  end
end
