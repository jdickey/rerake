
require 'test_helper'

require 'rerake/parser/simple_cov'

describe 'Rerake::Parser::SimpleCov' do
  let(:described_class) { ::Rerake::Parser::SimpleCov }
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

    describe 'when given valid SimpleCov input' do
      describe 'assigns correct values for' do
        let(:counts) do
          {
            covered_lines: 45,
            lines:         50,
            coverage:      90.0
          }
        end
        let(:input) do
          "blah blah blah\n" \
          "we don't care about anything not matching SimpleCov format\n" \
          'Coverage report generated for Unit Tests to /some/dir. ' \
          "#{counts[:covered_lines]} / #{counts[:lines]} LOC " \
          "(#{counts[:coverage]}%) covered.\n" \
          "more junk may well appear afterwards\n"
            .split("\n")
        end

        [:covered_lines, :lines, :coverage].each do |which|
          it "#{which}" do
            expect(obj.counts[which]).must_equal counts[which]
          end
        end
      end # describe 'assigns correct values for'
    end # describe 'when given valid SimpleCov input'

    describe 'when given invalid SimpleCov output' do
      let(:input) { 'this is invalid SimpleCov output. deal with it, buddy.' }

      it 'maintains zero values for all counts' do
        expect(obj.counts.values.detect(&:nonzero?)).must_be_nil
      end
    end # describe 'when given invalid SimpleCov output'
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::SimpleCov'
