module Notifyme
  class Notify
    class << self
      NOTIFY_REQUIRED_FIELDS = [:content_type, :content].freeze

      def notify(data)
        notify_validate_required_fields(data)
        Notifyme::TelegramBot::Bot.send_message(
          data[:content_type],
          data[:content],
          chat_ids
        )
      end

      private

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
