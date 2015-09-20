
require 'test_helper'

require 'rerake/command_output'

describe 'Rerake::CommandOutput' do
  let(:described_class) { Rerake::CommandOutput }

  describe 'when a successful shell command is specified to #initialize' do
    let(:obj) { described_class.new 'ls' }

    it 'returns a status indicating exit code of 0' do
      expect(obj.status).must_equal 0
    end

    it 'indicates that there were no errors' do
      expect(obj.errors).must_be_empty
    end

    it 'produces the expected output' do
      output = obj.output
      expect(output).must_be_instance_of Array
      expect(output).wont_be_empty
      expect(output.reject { |s| s.instance_of? String }).must_be_empty
    end
  end # describe 'when a successful shell command is specified to #initialize'

  describe 'when an unsuccessful command is specified to #initialize' do
    let(:obj) { described_class.new 'ls /foo/bar/this/does/not/exist' }

    it 'returns a status indicating a nonzero exit code' do
      expect(obj.status).wont_equal 0
    end

    it 'indicates that there were errors' do
      expect(obj.errors).wont_be_empty
    end

    it 'produces the expected output' do
      expect(obj.output).must_be_empty
    end
  end # describe 'when an unsuccessful command is specified to #initialize'
end
