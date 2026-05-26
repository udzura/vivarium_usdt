# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rb_sys/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("vivarium_usdt.gemspec")

RbSys::ExtensionTask.new("vivarium_usdt", GEMSPEC) do |ext|
  ext.lib_dir = "lib/vivarium_usdt"
end

task default: %i[compile test]
