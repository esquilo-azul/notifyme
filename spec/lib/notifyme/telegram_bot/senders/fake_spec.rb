# frozen_string_literal: true

RSpec.describe Notifyme::TelegramBot::Senders::Fake do
  context 'when first message is send' do
    before do
      Notifyme::TelegramBot::Bot.send_message(:plain, 'Test 1!', [12_345_678])
    end

    it do
      expect(described_class.messages.last).to eq(
        { content_type: :plain, content: 'Test 1!', chat_ids: [12_345_678] }
      )
    end
  end

  context 'when second message is send' do
    before do
      Notifyme::TelegramBot::Bot.send_message(:html, '<b>Test 2!</b>', [12_345_678])
    end

    it do
      expect(described_class.messages.last).to eq(
        { content_type: :html, content: '<b>Test 2!</b>', chat_ids: [12_345_678] }
      )
    end
  end
end
