# frozen_string_literal: true

Issue.patch_self(Notifyme::Patches::IssuePatch)
Repository.patch_self(Notifyme::Patches::RepositoryPatch)
User.patch_self(Notifyme::Patches::UserPatch)
UsersHelper.prepend(Notifyme::Patches::UsersHelperPatch)

require_dependency 'notifyme/hooks/add_my_email_extra_link'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'
