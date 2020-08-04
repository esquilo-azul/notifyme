# coding: utf-8

require 'redmine'

require 'notifyme/patches/issue_patch'
require 'notifyme/patches/users_helper_patch'
require 'notifyme/patches/repository_patch'
require 'notifyme/patches/user_patch'
require_dependency 'notifyme/hooks/add_my_email_extra_link'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'

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
