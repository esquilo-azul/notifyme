module Notifyme
  class Notify
    class << self
      NOTIFY_REQUIRED_FIELDS = [:content_type, :content].freeze

      def notify(data)
        notify_validate_required_fields(data)
        if data[:content_type] == :plain
          telegram_message(data[:content])
        elsif data[:content_type] == :html
          telegram_html(data[:content])
        else
          raise "Unknown notify content type: \"#{data[:content_type]}\""
        end
      end

      private

      def telegram_html(html)
        Notifyme::TelegramBot::Bot.new.send_html_photo_multiple_chat(html, chat_ids)
      end

      def telegram_message(text)
        Notifyme::TelegramBot::Bot.new.send_message_multiple_chat(text, chat_ids)
      end

      def notify_validate_required_fields(data)
        NOTIFY_REQUIRED_FIELDS.each do |f|
          raise "Field \"#{f}\" not found in notify data: #{data}" unless data.key?(f)
        end
      end

      def chat_ids
        TelegramChat.where.not(user: nil).joins(:user)
                    .where(users: { status: User::STATUS_ACTIVE }).pluck(:chat_id)
      end
    end
  end
end
