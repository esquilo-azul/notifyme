# frozen_string_literal: true

source = Notifyme::Patches::IssuePatch
target = Issue
target.send(:include, source) unless target.include?(source)
unless Repository.include?(Notifyme::Patches::RepositoryPatch)
  Repository.include Notifyme::Patches::RepositoryPatch
end
User.include Notifyme::Patches::UserPatch unless User.include?(Notifyme::Patches::UserPatch)
UsersHelper.prepend(Notifyme::Patches::UsersHelperPatch)

require_dependency 'notifyme/hooks/add_my_email_extra_link'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'
