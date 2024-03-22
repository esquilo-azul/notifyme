# frozen_string_literal: true

RSpec.describe ::Notifyme::Notify do
  fixtures :users, :roles, :trackers, :enumerations, :issue_statuses

  before do
    Setting.plugin_notifyme = Setting.plugin_notifyme.merge(
      issue_update_event_notify: true,
      issue_create_event_notify: true
    )
  end

  it { expect(::Notifyme::TelegramBot::Senders::Fake.messages).to be_empty }

  describe 'no self notified configuration' do
    let(:user_source_class) do
      ::Class.new do
        attr_reader :notifyme_notified_users

        def initialize(user)
          @notifyme_notified_users = [user]
        end
      end
    end
    let(:user) { users(:users_002) } # rubocop:disable Naming/VariableNumber
    let(:telegram_chat) do
      ::TelegramChat.create!(chat_id: 12_345_678, chat_type: 'private', chat_name: 'Admin',
                             user: user)
    end
    let(:source) { user_source_class.new(telegram_chat.user) }

    before do
      described_class.notify(content_type: :plain, content: 'Test 1!', author: user,
                             source: source)
    end

    it { expect(user.telegram_pref.no_self_notified).to be_falsy }

    it {
      expect(Notifyme::TelegramBot::Senders::Fake.messages.last).to eq(
        { content_type: :plain, content: 'Test 1!', chat_ids: [12_345_678] }
      )
    }

    context 'when no self notified is checked' do
      before do
        user.telegram_pref.no_self_notified = true
        user.telegram_pref.save || raise('Unsaved')
        Notifyme::Notify.notify(content_type: :plain, content: 'Test 2!', author: user,
                                source: source)
      end

      it {
        expect(Notifyme::TelegramBot::Senders::Fake.messages.last).to eq(
          { content_type: :plain, content: 'Test 2!', chat_ids: [] }
        )
      }

      context 'when message with no author is send' do
        before do
          Notifyme::Notify.notify(content_type: :plain, content: 'Test 3!', author: nil,
                                  source: source)
        end

        it {
          expect(Notifyme::TelegramBot::Senders::Fake.messages.last).to eq(
            { content_type: :plain, content: 'Test 3!', chat_ids: [12_345_678] }
          )
        }
      end
    end
  end

  describe 'issues configuration' do
    def create_user(login)
      u = ::User.new(firstname: login, lastname: 'Stubbed', mail: "#{login}@stubworld.net")
      u.login = login + '_stub'
      u.save!
      ::Member.create!(project: the_project, user: u, roles: [::Role.first],
                       mail_notification: true)
      u
    end

    let(:the_project) { ::Project.create!(name: 'Stubbed project', identifier: 'stubbed_project') }
    let(:notified_user) { create_user('Notified') }
    let(:notifier_user) { create_user('Notifier') }
    let(:the_telegram_chat) do
      ::TelegramChat.create!(user: notified_user, chat_id: 112_729_332,
                             chat_name: 'Stub Chat', chat_type: 'private')
    end

    before do
      the_project
      notified_user
      notifier_user
      the_telegram_chat
    end

    {
      [:notifier, nil] => [true, false, true, false, false, false, false],
      [:notified, nil] => [true, true, true, true, false, true, false],
      [:notifier, :notified] => [true, true, true, true, true, false, false], # rubocop:disable Style/SymbolArray
      [:notified, :notified] => [true, true, true, true, true, true, false] # rubocop:disable Style/SymbolArray
    }.each do |users, v|
      [['all'], ['selected'], ['selected', true], ['only_my_events'], ['only_assigned'],
       ['only_owner'], ['none']].each_with_index do |prefs, index|
        context "when {author: #{users[0]}, assigned: #{users[1].if_present('nil')}" \
                ", issues_pref: #{prefs[0]}, issues_pref_projects: #{prefs[1] ? 'true' : 'false'}}" do # rubocop:disable Layout/LineLength
          let(:author) { send("#{users[0]}_user") }
          let(:assigned) { users[1].if_present { |x| send("#{x}_user") } }
          let(:issue) do
            ::Issue.create!(project: the_project, author: author, subject: 'STUUUUB!',
                            assigned_to: assigned, tracker: ::Tracker.first,
                            priority: ::IssuePriority.first, status: IssueStatus.find(1))
          end
          let(:issues_project_ids) { prefs[1] ? [the_project.id] : [] }
          let(:issues_pref) { prefs[0] }
          let(:notified) { v[index] ? 'to' : 'not_to' }
          let(:user_telegram_prefs_save_result) do
            ::UserTelegramPreferences.new(
              user: notified_user, no_self_notified: false,
              issues: issues_pref, issues_project_ids: issues_project_ids
            ).save
          end
          let(:last_message) { ::Notifyme::TelegramBot::Senders::Fake.messages.last }

          before do
            user_telegram_prefs_save_result
            last_message
            issue.reload
            issue.init_journal(notifier_user, "New note! #{::Time.zone.now}")
            issue.save!
          end

          it { expect(:user_telegram_prefs_save_result).to be_truthy }
          it { expect(notified_user.telegram_pref.no_self_notified).to eq(false) }
          it { expect(notified_user.telegram_pref.issues).to eq(issues_pref) }
          it { expect(notified_user.telegram_pref.issues_project_ids).to eq(issues_project_ids) }

          it do
            expect(::Notifyme::TelegramBot::Senders::Fake.messages.last).not_to eq(last_message)
          end

          it do
            expect(::Notifyme::TelegramBot::Senders::Fake.messages.last[:chat_ids])
              .send(notified, include(the_telegram_chat.chat_id))
          end
        end
      end
    end
  end
end
