# frozen_string_literal: true

RedmineEventsManager.add_listener(Issue, :create, 'Notifyme::Events::Issue::Create')
RedmineEventsManager.add_listener(Issue, :update, 'Notifyme::Events::Issue::Update')
RedmineEventsManager.add_listener(Repository, :receive, 'Notifyme::Events::Repository::Receive')
RedmineEventsManager.add_listener(TimeEntry, :create, 'Notifyme::Events::TimeEntry::Create')
RedmineEventsManager.add_listener(TimeEntry, :delete, 'Notifyme::Events::TimeEntry::Delete')
RedmineEventsManager.add_listener(TimeEntry, :update, 'Notifyme::Events::TimeEntry::Update')
