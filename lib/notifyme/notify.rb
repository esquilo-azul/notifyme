module Notifyme
  class Notify
    class << self
      def telegram(html)
        Notifyme::TelegramBot::Bot.new.send_html_photo_multiple_chat(html, chat_ids)
      end

      private

      def chat_ids
        TelegramChat.where.not(user: nil).joins(:user)
                    .where(users: { status: User::STATUS_ACTIVE }).pluck(:chat_id)
      end
    end
  end
end
