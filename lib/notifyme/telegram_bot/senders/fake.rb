# frozen_string_literal: true

module Notifyme
  module TelegramBot
    module Senders
      class Fake < ::Notifyme::TelegramBot::Senders::Real
        class << self
          def send_message(content_type, content, chat_ids)
            super
            messages << {
              content_type: content_type,
              content: content,
              chat_ids: chat_ids
            }
          end

          def messages
            @messages ||= []
          end

          protected

          def telegram_send_message(options); end

          # @return [Telegram::Bot::Types::Message]
          def telegram_send_photo(_options)
            ::Telegram::Bot::Types::Message.new(
              message_id: 1, date: 0, chat: { id: 1, type: 'private' },
              photo: [{ file_id: '1234', file_unique_id: '1234', width: 1, height: 1 }]
            )
          end
        end
      end
    end
  end
end
