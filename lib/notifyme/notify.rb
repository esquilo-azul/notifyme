module Notifyme
  class Notify
    class << self
      NOTIFY_REQUIRED_FIELDS = [:author, :content_type, :content, :source].freeze

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
        users = notified_users(source)
        return users unless author.present?
        users.select { |u| u != author || !u.telegram_pref.no_self_notified }
      end

      def notified_users(source)
        telegram_mail_notification_suppress.on_suppress do
          source.notified_users
        end
      end

      def telegram_mail_notification_suppress
        @telegram_mail_notification_suppresss ||= telegram_mail_notification_suppresss_uncached
      end

      def telegram_mail_notification_suppresss_uncached
        s = ::Notifyme::Utils::SuppressClassMethod.new
        ::User.new # Force ":mail_notification" method creation
        s.add(::User, :mail_notification) do
          telegram_pref.issues
        end
        ::Member.new # Force ":mail_notification?" method creation
        s.add(::Member, :mail_notification?) do
          principal.telegram_pref.issues_project_ids.include?(project_id)
        end
        s
      end
    end
  end
end
