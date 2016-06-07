module Notifyme
  class Settings
    def self.telegram_bot_default_chat_id
      raise "Chave do Bot Telegram não foi atribuída. Acesse /settings/plugin/notifyme para " \
        'atribuir uma.' unless Setting.plugin_notifyme['telegram_bot_default_chat_id'].present?
      Setting.plugin_notifyme['telegram_bot_default_chat_id']
    end

    def self.telegram_bot_name
      Setting.plugin_notifyme[__method__]
    end

    def self.telegram_default_chat_id
      Setting.plugin_notifyme[__method__]
    end

    def self.telegram_chat_id(chat_id = nil)
      return chat_id if chat_id.present?
      return telegram_default_chat_id if telegram_default_chat_id.present?
      raise "O ID do chat Telegram não foi informado e não está registrado um ID padrão. Informe" \
        " o ID do chat ou registre um ID padrão em /settings/plugin/notifyme."
    end

    def self.issue_create_event_notify
      Setting.plugin_notifyme[__method__]
    end

    def self.issue_update_event_notify
      Setting.plugin_notifyme[__method__]
    end
  end
end
