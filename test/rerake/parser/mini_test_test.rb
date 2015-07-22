
require 'test_helper'

require 'pry-byebug'

require 'rerake/parser/mini_test'

describe 'Rerake::Parser::MiniTest' do
  let(:described_class) { ::Rerake::Parser::MiniTest }
  let(:obj) { described_class.new input }

  describe 'is initialised to a known state, with zero values for' do
    let(:input) { :whatever_as_long_as_parse_not_called }
    let(:counts) { obj.counts }

    it 'all counts' do
      expect(counts.values.detect(&:nonzero?)).must_be_nil
    end
  end # describe 'is initialised to a known state, with zero values for'

  describe 'has a #parse method that' do
    let(:obj) { described_class.new(input).parse }

    describe 'when given valid MiniTest output' do
      describe 'assigns correct values for' do
        # MiniTest won't let us use variables like 'assertions'. :disappointed:
        let(:counts) do
          {
            assertions: 24,
            errors: 2,
            failures: 3,
            skips: 4,
            tests: 16
          }
        end
        let(:input) do
          "Other junk might be before the important line\n" \
          "Even more junk might be before the important line\n" \
          "Output might include terminal colour control sequences, or not\n" \
          "\e[32m#{counts[:tests]} tests, " \
          "#{counts[:assertions]} assertions, " \
          "#{counts[:failures]} failures, " \
          "#{counts[:errors]} errors, " \
          "#{counts[:skips]} skips" \
          "\e[0m\n" \
          "More junk might be after it; we shouldn't care.\n"
            .split("\n")
        end

        [:assertions, :errors, :failures, :skips, :tests].each do |which|
          it "#{which}" do
            expect(obj.counts[which]).must_equal counts[which]
          end
        end
      end # describe 'assigns correct values for'
    end # describe 'when given valid MiniTest output'

    describe 'when given invalid MiniTest output' do
      let(:input) { 'this is invalid MiniTest output. deal with it, buddy.' }

      it 'maintains zero values for all counts' do
        expect(obj.counts.values.detect(&:nonzero?)).must_be_nil
      end
    end
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::MiniTest'
