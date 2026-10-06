# frozen_string_literal: true

Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
            caption: :label_telegram_chats
end
