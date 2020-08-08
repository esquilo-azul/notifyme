# frozen_string_literal: true

module Notifyme
  class TestConfig
    def before_each
      ::Notifyme::TelegramBot::Senders::Fake.messages.clear
    end
  end
end
