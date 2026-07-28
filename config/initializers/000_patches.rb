# frozen_string_literal: true

Issue.patch_self(Notifyme::Patches::Issue)
Repository.patch_self(Notifyme::Patches::Repository)
User.patch_self(Notifyme::Patches::User)
UsersHelper.prepend(Notifyme::Patches::UsersHelper)

require_dependency 'notifyme/hooks/add_my_email_extra_link'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'
