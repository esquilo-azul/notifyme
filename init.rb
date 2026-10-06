# frozen_string_literal: true

require 'redmine'
require 'notifyme/version'

Redmine::Plugin.register :notifyme do
  name 'Notify me'
  author Notifyme::AUTHOR
  description Notifyme::SUMMARY
  version Notifyme::VERSION

  settings(default: {}, partial: 'settings/notifyme')
end
