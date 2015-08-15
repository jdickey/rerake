require "bundler/gem_tasks"
require "rake/testtask"

require 'cane/rake_task'
require 'rake/tasklib'
require 'rake/testtask'
require 'flay_task'
require 'flog'
require 'flog_task'
require 'reek/rake/task'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = [
    'app/**/*.rb',
    'test/**/*.rb'
  ]
  task.formatters = ['simple', 'd']
  task.fail_on_error = true
  # task.options << '--rails'
  task.options << '--display-cop-names'
end

Reek::Rake::Task.new do |t|
  t.source_files = "{lib,test}/**/*.rb"
  t.reek_opts = '--sort-by smelliness -s'
end

FlayTask.new do |t|
  t.verbose = true
  t.dirs = %w(lib)
end

FlogTask.new do |t|
  t.verbose = true
  t.threshold = 250 # default is 200
  t.instance_variable_set :@methods_only, true
  t.dirs = %w(lib) # Look, Ma! No tests! (Run for `test` periodically.)
end

Cane::RakeTask.new do |t|
  t.abc_max = 8
  t.abc_glob = '{lib}/**/*.rb'
  t.style_glob = '{lib,test}/**/*.rb'
end

# Coveralls not set up yet
# require 'coveralls/rake/task'
# Coveralls::RakeTask.new

task(:default).clear
task default: [:test, :rubocop, :flay, :flog, :reek, :cane]
