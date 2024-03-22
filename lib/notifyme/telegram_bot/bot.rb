# frozen_string_literal: true

require 'telegram/bot'

module Notifyme
  module TelegramBot
    class Bot
      class << self
        def run(&block)
          Telegram::Bot::Client.run(Notifyme::Settings.telegram_bot_default_chat_id, &block)
        end

        def send_message(content_type, content, chat_ids)
          if Rails.env.test?
            ::Notifyme::TelegramBot::Senders::Fake.send_message(content_type, content, chat_ids)
          else
            ::Notifyme::TelegramBot::Senders::Real.send_message(content_type, content, chat_ids)
          end
        end
      end
    end
  end
end
