require 'telegram/bot'

module Notifyme
  module TelegramBot
    class Bot
      def run
        Telegram::Bot::Client.run(Settings.telegram_bot_default_chat_id) do |bot|
          yield(bot)
        end
      end

      def send_message(messages, chat_id = nil)
        messages = [messages] unless messages.is_a?(Array)
        run do |bot|
          messages.each do |message|
            bot.api.sendMessage(chat_id: Settings.telegram_chat_id(chat_id), text: message)
          end
        end
      end
    end
  end
end
