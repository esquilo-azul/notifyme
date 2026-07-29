# frozen_string_literal: true

module Notifyme
  module Patches
    module Issue
      def self.included(base)
        base.send(:include, NotifymeNotifiedUsers)
      end

      module NotifymeNotifiedUsers
        enable_memoized

        def notifyme_notified_users
          telegram_mail_notification_suppress.on_suppress do
            notified_users
          end
        end

        private

        # @return [Notifyme::Utils::SuppressClassMethod]
        memoize def telegram_mail_notification_suppress
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
end
