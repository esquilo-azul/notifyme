# frozen_string_literal: true

namespace :notifyme do
  Rake::TestTask.new(test: 'db:test:prepare') do |t|
    plugin_root = ::File.dirname(::File.dirname(__dir__))

    t.description = 'Run plugin notifyme\'s tests.'
    t.libs << 'test'
    t.test_files = ["#{plugin_root}/test/**/*_test.rb"]
    t.verbose = true
  end
end
