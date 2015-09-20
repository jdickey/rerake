# Rerake

[![Code Climate](https://codeclimate.com/github/jdickey/rerake/badges/gpa.svg)](https://codeclimate.com/github/jdickey/rerake)
[![Coverage Status](https://coveralls.io/repos/jdickey/rerake/badge.png?branch=master&service=github)](https://coveralls.io/github/jdickey/rerake?branch=master)

Rerake is so called because it "runs `rake` again", producing a formatted summary of results suitable for inclusion in a commit message in your SCM tool of choice.

When run from your project root directory, it runs the default `rake` task, capturing its output, and then produces one-line summaries for each of the following:

1. MiniTest test results (RSpec support coming soon);
1. Test coverage as reported by SimpleCov;
1. RuboCop results (number of files inspected and number of offences found);
1. Flay total score;
1. Flog result &mdash; total score, method average, and method high score (with name of method);
1. Reek total number of warnings.

If a tool's reporting cannot be found in the `rake` output parsed by Rerake, the corresponding report line will be silently omitted.

Very early versions of this tool included support for [Cane](https://github.com/square/cane). I've removed it as its capabilities are (apparently) made redundant by other tools, and because testing (of version 2.6.2) yielded numerous apparent false negatives. It is no longer a development dependency of this Gem or application.

## Installation

Add this line to your application's Gemfile to use the API:

```ruby
gem 'rerake'
```

And then execute:

    $ bundle

Or install the command-line tool as well as the API as:

    $ gem install rerake

## Usage

If installed using your application's `Gemfile`, then run

    $ bundle exec rerake

If, on the other hand, you've installed it as the regular command-line tool, then run

    $ rerake

as you would any other command.

### On Dependencies

The various tools supported by `rerake` are listed as *development* dependencies because *your* default Rake task might not include all of them. `Rerake` doesn't assume that you're running different tools, or that you're doing things in a different order. It should be able to find the output of any supported tool that's included as part of your default Rake task (what's run when you enter `bundle exec rake` at the command line).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec rerake` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jdickey/rerake. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
