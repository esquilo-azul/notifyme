# frozen_string_literal: true

require 'notifyme/events/issue/update'

RSpec.describe ::Notifyme::Events::Issue::Update do
  fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers, :users,
           :members

  before do
    Setting.plugin_notifyme = Setting.plugin_notifyme.merge(issue_update_event_notify: true)
    EventsManager.delay_disabled = true
    EventsManager.log_exceptions_disabled = true
    EventsManager::Settings.event_exception_unchecked = false
  end

  it do
    expect(::Notifyme::Settings.issue_update_event_notify).to be_truthy
  end

  context 'when issue journal is created' do
    let(:last_message) { ::Notifyme::TelegramBot::Senders::Fake.messages.last }
    let(:issue) { ::Issue.first }
    let(:issue_updated_on) { issue.updated_on }

    before do
      last_message
      issue_updated_on
      issue.init_journal(::User.find(1), <<~NOTE_MESSAGE)
        Comentário com um título ("hX").

        h2. TITULO
      NOTE_MESSAGE
      issue.save!
      issue.reload
    end

    it { expect(issue.updated_on).not_to eq(issue_updated_on) }
    it { expect(::Notifyme::TelegramBot::Senders::Fake.messages.last).not_to eq(last_message) }
    it { expect(::Notifyme::TelegramBot::Senders::Fake.messages.last).to be_present }
  end
end
