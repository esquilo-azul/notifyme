# frozen_string_literal: true

require 'redmine_plugins_helper/plugin_rake_task'
::RedminePluginsHelper::PluginRakeTask.register(:notifyme, :test)

namespace :notifyme do
  task assignee_reminder: :environment do
    Mailer.with_synched_deliveries do
      AssigneeReminderMailer.remind_all_users
    end
  end
end
