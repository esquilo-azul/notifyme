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
          Notifyme::Events::Issue::Update.new(self).notify if journalized_type == 'Issue'
        end
      end
    end
  end
end

unless Journal.included_modules.include? Notityme::Patches::JournalPatch
  Journal.send(:include, Notityme::Patches::JournalPatch)
end
