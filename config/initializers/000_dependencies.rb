# frozen_string_literal: true

Redmine::Plugin.post_register :notifyme do
  # Source: https://github.com/esquilo-azul/redmine_events_manager
  requires_redmine_plugin(:redmine_events_manager, version_or_higher: '0.4.2')
end
