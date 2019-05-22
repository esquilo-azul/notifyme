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
    end
  end
end
