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

        # @param suppress [Notifyme::Utils::SuppressClassMethod]
        # @return [void]
        def suppress_member_methods(suppress)
          ::Member.new # Force ":mail_notification?" method creation
          suppress.add(::Member, :mail_notification?) do
            principal.telegram_pref.issues_project_ids.include?(project_id)
          end
        end

        # @param suppress [Notifyme::Utils::SuppressClassMethod]
        # @return [void]
        def suppress_project_methods(suppress)
          suppress.add(::Project, :notified_users) do
            members.includes(:principal).select(&:mail_notification?).filter_map(&:principal) |
              users.select { |u| u.mail_notification == 'all' }
          end
        end

        # @param suppress [Notifyme::Utils::SuppressClassMethod]
        # @return [void]
        def suppress_user_methods(suppress)
          ::User.new # Force ":mail_notification" method creation
          suppress.add(::User, :mail_notification) do
            telegram_pref.issues
          end
        end

        # @return [Notifyme::Utils::SuppressClassMethod]
        memoize def telegram_mail_notification_suppress
          %i[user member project]
            .each_with_object(::Notifyme::Utils::SuppressClassMethod.new) do |e, a|
            send(:"suppress_#{e}_methods", a)
          end
        end
      end
    end
  end
end
