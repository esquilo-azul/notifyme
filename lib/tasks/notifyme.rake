# frozen_string_literal: true

require 'redmine_plugins_helper/test_tasks/auto'
RedminePluginsHelper::TestTasks::Auto.register(:notifyme)

namespace :notifyme do
  task assignee_reminder: :environment do
    Mailer.with_synched_deliveries do
      AssigneeReminderMailer.remind_all_users
    end
  end
end
