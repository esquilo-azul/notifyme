module Notityme
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :issue_create_event
        end
      end

      module InstanceMethods
        def issue_create_event
          Notifyme::Events::Issue::Add.new(self).notify
        end
      end
    end
  end
end

unless Issue.included_modules.include? Notityme::Patches::IssuePatch
  Issue.send(:include, Notityme::Patches::IssuePatch)
end
