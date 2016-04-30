require 'telegram/bot'

module Notifyme
  module TelegramBot
    class MessageListener
      def run
        Telegram::Bot::Client.run(Settings.telegram_bot_default_chat_id) do |bot|
          bot.listen do |message|
            Rails.logger.debug message.inspect
            add_or_update_chat(message.chat)
          end
        end
      end

      private

      def add_or_update_chat(chat)
        c = TelegramChat.find_by_chat_id(chat.id)
        c = TelegramChat.new(chat_id: chat.id) unless c
        c.chat_name = chat_name(chat)
        c.chat_type = chat.type
        c.save!
      end

      def chat_name(chat)
        return [chat.first_name, chat.last_name].join(' ') if chat.type == 'private'
        return chat.title if chat.type == 'group'
        '?'
      end
    end
  end
end
