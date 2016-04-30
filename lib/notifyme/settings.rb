module Notifyme
  class Settings
    def self.telegram_bot_default_chat_id
      raise "Chave do Bot Telegram não foi atribuída. Acesse /settings/plugin/notifyme para " \
        'atribuir uma.' unless Setting.plugin_notifyme['telegram_bot_default_chat_id'].present?
      Setting.plugin_notifyme['telegram_bot_default_chat_id']
    end
  end
end
