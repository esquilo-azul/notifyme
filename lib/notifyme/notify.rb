module Notifyme
  class Notify
    class << self
      def telegram_html(html)
        Notifyme::TelegramBot::Bot.new.send_html_photo_multiple_chat(html, chat_ids)
      end

      def telegram_message(text)
        Notifyme::TelegramBot::Bot.new.send_message_multiple_chat(text, chat_ids)
      end

      private

      def chat_ids
        TelegramChat.where.not(user: nil).joins(:user)
                    .where(users: { status: User::STATUS_ACTIVE }).pluck(:chat_id)
      end
    end
  end
end
