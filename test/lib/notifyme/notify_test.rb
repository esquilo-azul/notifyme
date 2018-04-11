require 'test_helper'

module Notifyme
  class NotifyTest < ActiveSupport::TestCase
    class UserSource
      attr_reader :notified_users

      def initialize(user)
        @notified_users = [user]
      end
    end
    fixtures :users, :roles, :trackers, :enumerations, :issue_statuses

    setup do
      Setting.plugin_notifyme = Setting.plugin_notifyme.merge(
        issue_update_event_notify: true,
        issue_create_event_notify: true
      )
      create_project
      create_notified_user
      create_notifier_user
      create_telegram_chat
    end

    def test_no_self_notified
      user = users(:users_002)
      TelegramChat.create!(chat_id: 12_345_678, chat_type: 'private', chat_name: 'Admin',
                           user: user)
      source = UserSource.new(user)
      assert_equal false, user.telegram_pref.no_self_notified

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 1!', author: user,
                              source: source)
      assert_equal({ content_type: :plain, content: 'Test 1!', chat_ids: [12_345_678] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)

      user.telegram_pref.no_self_notified = true
      assert user.telegram_pref.save

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 2!', author: user,
                              source: source)
      assert_equal({ content_type: :plain, content: 'Test 2!', chat_ids: [] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 3!', author: nil,
                              source: source)
      assert_equal({ content_type: :plain, content: 'Test 3!', chat_ids: [12_345_678] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)
    end

    def test_issues
      create_issue(@notifier, nil)
      assert_issue_notify('all', true)
      assert_issue_notify('selected', false, [])
      assert_issue_notify('selected', true, [@project.id])
      assert_issue_notify('only_my_events', false)
      assert_issue_notify('only_assigned', false)
      assert_issue_notify('only_owner', false)
      assert_issue_notify('none', false)
      create_issue(@notified, nil)
      assert_issue_notify('all', true)
      assert_issue_notify('selected', true, [])
      assert_issue_notify('selected', true, [@project.id])
      assert_issue_notify('only_my_events', true)
      assert_issue_notify('only_assigned', false)
      assert_issue_notify('only_owner', true)
      assert_issue_notify('none', false)
      create_issue(@notifier, @notified)
      assert_issue_notify('all', true)
      assert_issue_notify('selected', true, [])
      assert_issue_notify('selected', true, [@project.id])
      assert_issue_notify('only_my_events', true)
      assert_issue_notify('only_assigned', true)
      assert_issue_notify('only_owner', false)
      assert_issue_notify('none', false)
      create_issue(@notified, @notified)
      assert_issue_notify('all', true)
      assert_issue_notify('selected', true, [])
      assert_issue_notify('selected', true, [@project.id])
      assert_issue_notify('only_my_events', true)
      assert_issue_notify('only_assigned', true)
      assert_issue_notify('only_owner', true)
      assert_issue_notify('none', false)
    end

    private

    def issues_preferences_update(issues, issues_project_ids)
      utp = ::UserTelegramPreference.new(user: @notified, no_self_notified: false, issues: issues,
                                         issues_project_ids: issues_project_ids)
      r = utp.save
      assert r, utp.errors.messages.to_s
      assert_equal false, @notified.telegram_pref.no_self_notified
      assert_equal issues, @notified.telegram_pref.issues
      assert_equal issues_project_ids, @notified.telegram_pref.issues_project_ids
    end

    def assert_issue_notify(issues, notified, issues_project_ids = [])
      issues_preferences_update(issues, issues_project_ids)
      assert_updated_issue
      chat_ids = ::Notifyme::TelegramBot::Senders::Fake.messages.last[:chat_ids]
      assert_equal notified, chat_ids.include?(@telegram_chat.chat_id),
                   "Telegram chat: #{@telegram_chat}, chat_ids: #{chat_ids}, issues: #{issues}, " \
                   "issues_project_ids: #{issues_project_ids}"
    end

    def create_notified_user
      @notified = create_user('Notified')
    end

    def create_notifier_user
      @notifier = create_user('Notifier')
    end

    def create_user(login)
      u = ::User.new(firstname: login, lastname: 'Stubbed', mail: "#{login}@stubworld.net")
      u.login = login + '_stub'
      u.save!
      ::Member.create!(project: @project, user: u, roles: [::Role.first], mail_notification: true)
      u
    end

    def create_telegram_chat
      @telegram_chat = ::TelegramChat.create!(user: @notified, chat_id: 112_729_332,
                                              chat_name: 'Stub Chat', chat_type: 'private')
    end

    def create_project
      @project = ::Project.create!(name: 'Stubbed project', identifier: 'stubbed_project')
    end

    def create_issue(author, assigned)
      @issue = ::Issue.create!(project: @project, author: author, subject: 'STUUUUB!',
                               assigned_to: assigned, tracker: ::Tracker.first,
                               priority: ::IssuePriority.first, status: IssueStatus.find(1))
    end

    def assert_updated_issue
      l = ::Notifyme::TelegramBot::Senders::Fake.messages.last
      i = ::Issue.find(@issue.id)
      i.reload
      @increment ||= 0
      @increment += 1
      i.init_journal(@notifier, "Updated: #{::Time.zone.now}|#{@increment}")
      i.save!
      assert_not_equal(l, ::Notifyme::TelegramBot::Senders::Fake.messages.last)
    end
  end
end
