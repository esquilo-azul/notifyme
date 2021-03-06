# frozen_string_literal: true

EventsManager.add_listener(Issue, :create, 'Notifyme::Events::Issue::Create')
EventsManager.add_listener(Issue, :update, 'Notifyme::Events::Issue::Update')
EventsManager.add_listener(Repository, :receive, 'Notifyme::Events::Repository::Receive')
EventsManager.add_listener(TimeEntry, :create, 'Notifyme::Events::TimeEntry::Create')
EventsManager.add_listener(TimeEntry, :delete, 'Notifyme::Events::TimeEntry::Delete')
EventsManager.add_listener(TimeEntry, :update, 'Notifyme::Events::TimeEntry::Update')
