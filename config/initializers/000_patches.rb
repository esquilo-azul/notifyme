# frozen_string_literal: true

require 'notifyme/patches/issue_patch'
require 'notifyme/patches/users_helper_patch'
require 'notifyme/patches/repository_patch'
require 'notifyme/patches/user_patch'
require_dependency 'notifyme/hooks/add_my_email_extra_link'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'
