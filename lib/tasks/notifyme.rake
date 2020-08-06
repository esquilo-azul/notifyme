# frozen_string_literal: true

require 'rspec/core/rake_task'

namespace :notifyme do
  ::RSpec::Core::RakeTask.new(:test) do |t|
    t.rspec_opts = "--pattern 'plugins/notifyme/spec/**/*_spec.rb'" \
      " --default-path 'plugins/redmine_plugins_helper/spec' --require spec_helper"
  end
  Rake::Task['notifyme:test'].enhance ['db:test:prepare']

  task assignee_reminder: :environment do
    Mailer.with_synched_deliveries do
      ::AssigneeReminderMailer.remind_all_users
    end
  end
end
