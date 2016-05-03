module Notityme
  module Patches
    module JournalPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :journal_create_event
        end
      end

      module InstanceMethods
        def journal_create_event
          return unless journalized_type == 'Issue' && Notifyme::Settings.issue_update_event_notify
          Notifyme::Events::Issue::Update.new(self).notify
        end
      end
    end
  end
end

unless Journal.included_modules.include? Notityme::Patches::JournalPatch
  Journal.send(:include, Notityme::Patches::JournalPatch)
end
