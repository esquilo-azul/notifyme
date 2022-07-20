# frozen_string_literal: true

require 'redmine'
require 'notifyme/version'

Redmine::Plugin.register :notifyme do
  name 'Notify me'
  author ::Notifyme::AUTHOR
  description ::Notifyme::SUMMARY
  version ::Notifyme::VERSION

  settings(default: {}, partial: 'settings/notifyme')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
              caption: :label_telegram_chats
  end
end
