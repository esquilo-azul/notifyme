# frozen_string_literal: true

module Notifyme
  module Patches
    module RepositoryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:include, NotifyMethods)
      end

      module InstanceMethods
        def branch_revision(branch_name)
          check_git_repository
          return nil unless branches

          b = branches.find { |x| x.to_s == branch_name }
          b ? b.revision : nil # rubocop:disable Style/SafeNavigation
        end

        def git_cmd(args)
          s = ''
          scm.send('git_cmd', args) do |io|
            s = io.read
          end
          s
        end

        def git_cmd_no_raise(args)
          git_cmd(args)
        rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
          nil
        end

        def commit_exist?(commit)
          s = git_cmd_no_raise(['cat-file', '-t', commit])
          s.strip! if s.is_a?(String)
          s == 'commit'
        end

        private

        def check_git_repository
          raise 'Not a git repository' unless is_a?(Repository::Git)
        end
      end

      module NotifyMethods
        def notifyme_notified_users
          telegram_mail_notification_suppress.on_suppress do
            project.notified_users
          end
        end

        private

        def telegram_mail_notification_suppress
          @telegram_mail_notification_suppress ||= telegram_mail_notification_suppresss_uncached
        end

        def telegram_mail_notification_suppresss_uncached
          s = ::Notifyme::Utils::SuppressClassMethod.new
          ::User.new # Force ":mail_notification" method creation
          s.add(::User, :mail_notification) do
            telegram_pref.git
          end
          ::Member.new # Force ":mail_notification?" method creation
          s.add(::Member, :mail_notification?) do
            principal.telegram_pref.git_project_ids.include?(project_id)
          end
          s
        end
      end
    end
  end
end

unless Repository.included_modules.include? Notifyme::Patches::RepositoryPatch
  Repository.include Notifyme::Patches::RepositoryPatch
end
