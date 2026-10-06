# frozen_string_literal: true

Redmine::Plugin.by_path(__FILE__).nonprojects_menu do |menu|
  menu.push_plugin_settings
  menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
            caption: :label_telegram_chats
end
