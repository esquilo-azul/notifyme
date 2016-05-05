# coding: utf-8

require 'redmine'

Redmine::Plugin.register :notifyme do
  name 'Notify me'
  author 'Eduardo Henrique Bogoni'
  description 'Notificações'
  version '0.1.0'

  settings(default: {}, partial: 'settings/notifyme')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
              caption: :label_telegram_chats
  end
end

Rails.configuration.to_prepare do
  EacBase::EventManager.add_listener(Issue, :create, 'Notifyme::Events::Issue::Create')
  EacBase::EventManager.add_listener(Issue, :update, 'Notifyme::Events::Issue::Update')
end
