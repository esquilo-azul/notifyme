# frozen_string_literal: true

module Notifyme
  class Settings
    class << self
      def telegram_bot_default_chat_id
        if Setting.plugin_notifyme['telegram_bot_default_chat_id'].blank?
          raise 'Chave do Bot Telegram não foi atribuída. Acesse /settings/plugin/notifyme para ' \
            'atribuir uma.'
        end
        Setting.plugin_notifyme['telegram_bot_default_chat_id']
      end

      def telegram_bot_name
        Setting.plugin_notifyme[__method__]
      end

      def issue_create_event_notify
        Setting.plugin_notifyme[__method__]
      end

      def issue_update_event_notify
        Setting.plugin_notifyme[__method__]
      end

      def assignee_reminder_query
        ::IssueQuery.find(setting_value_or_raise('assignee_reminder_query_id').to_i)
      end

      def assignee_reminder_query_id_values
        ::IssueQuery.visible.where(project_id: nil)
      end

      private

      def setting_value_or_raise(key)
        v = Setting.plugin_notifyme[key]
        return v if v.present?

        raise "Setting.plugin_notifyme['#{key}'] is blank. " \
          "Set it in Notifyme's plugin configuration page."
      end
    end
  end
end
