
module Rerake
  module Parser
    # Parses MiniTest (Spec/Unit) output, storing reported count values.
    class MiniTest
      # Wraps the various counters for the MiniTest parser.
      class Counts
        # Internal methods that neither affect nor depend on instance state.
        module Internals
          def self.captures_as_ints(captures)
            captures.map(&:to_i)
          end
        end
        private_constant :Internals

        extend Forwardable

        def initialize(keys)
          @value = Struct.new(*keys).new
          @value.members.each { |key| @value[key] = 0 }
          self
        end

        def assign_from(captures)
          each_capture_with_index(captures) do |value, index|
            @value[@value.members[index]] = value
          end
        end

        def to_hash
          @value.to_h
        end

        def to_s
          to_hash.to_h.to_s
        end

        def_delegator :to_hash, :values
        def_delegator :to_hash, :[]

        private

        # This method smells of :reek:UtilityFunction
        def each_capture_with_index(captures)
          Internals.captures_as_ints(captures).each_with_index do |value, index|
            yield value, index
          end
        end
      end # class Rerake::Parser::MiniTest::Counts
    end # class Rerake::Parser::MiniTest
  end
end
