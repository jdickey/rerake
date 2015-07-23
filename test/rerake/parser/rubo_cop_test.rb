
require 'test_helper'

require 'rerake/parser/rubo_cop'

describe 'Rerake::Parser::RuboCop' do
  let(:described_class) { ::Rerake::Parser::RuboCop }
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

    describe 'when given valid RuboCop input' do
      describe 'which reports detected offenses' do
        describe 'assigns correct values for' do
          let(:counts) do
            {
              files:    20,
              offenses: 3
            }
          end
          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching RuboCop format\n" \
            "#{counts[:files]} files inspected," \
            " #{counts[:offenses]} offenses detected\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          [:files, :offenses].each do |which|
            it "#{which}" do
              expect(obj.counts[which]).must_equal counts[which]
            end
          end
        end # describe 'assigns correct values for'
      end # describe 'which reports detected offenses'

      describe 'which reports no detected offenses' do
        describe 'assigns correct values for' do
          let(:counts) do
            {
              files:    7,
              offenses: 0
            }
          end
          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching RuboCop format\n" \
            "#{counts[:files]} files inspected, no offenses detected\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          [:files, :offenses].each do |which|
            it "#{which}" do
              expect(obj.counts[which]).must_equal counts[which]
            end
          end
        end # describe 'assigns correct values for'
      end # describe 'which reports no detected offenses'
    end # describe 'when given valid RuboCop input'

    describe 'when given invalid RuboCop input' do
      let(:input) { 'this is invalid RuboCop output. deal with it, buddy.' }

      it 'maintains zero values for all counts' do
        expect(obj.counts.values.detect(&:nonzero?)).must_be_nil
      end
    end # describe 'when given invalid RuboCop input'
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::RuboCop'
