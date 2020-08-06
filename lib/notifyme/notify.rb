# frozen_string_literal: true

module Notifyme
  class Notify
    class << self
      NOTIFY_REQUIRED_FIELDS = %i[author content_type content source].freeze

      def notify(data)
        notify_validate_required_fields(data)
        Notifyme::TelegramBot::Bot.send_message(
          data[:content_type],
          data[:content],
          chat_ids(data[:author], data[:source])
        )
      end

      private

      def notify_validate_required_fields(data)
        NOTIFY_REQUIRED_FIELDS.each do |f|
          raise "Field \"#{f}\" not found in notify data: #{data}" unless data.key?(f)
        end
      end

      def chat_ids(author, source)
        users(author, source).flat_map { |u| u.telegram_chats.pluck(:chat_id) }
      end

      def users(author, source)
        users = source.notifyme_notified_users
        return users if author.blank?

        users.select { |u| u != author || !u.telegram_pref.no_self_notified }
      end
    end
  end
end
