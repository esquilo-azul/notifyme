# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :notifyme do
  name 'Notify me'
  author ::EacRedmineBase0::AUTHOR
  description ::EacRedmineBase0::SUMMARY
  version ::EacRedmineBase0::VERSION

  settings(default: {}, partial: 'settings/notifyme')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
              caption: :label_telegram_chats
  end
end
