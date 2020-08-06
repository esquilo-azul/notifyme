# frozen_string_literal: true

module Notifyme
  module TelegramBot
    module Commands
      class Echo
        include AbstractCommand

        def run
          return if send_text.blank?

          bot.api.sendMessage(chat_id: message.chat.id, text: send_text)
        end

        private

        def send_text
          args.join(' ').strip
        end
      end
    end
  end
end
