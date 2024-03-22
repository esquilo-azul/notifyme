# frozen_string_literal: true

module Notifyme
  module Patches
    module UsersHelperPatch
      def self.included(base)
        require_dependency 'users_helper'
        base.prepend(InstanceMethods)
      end

      module InstanceMethods
        def user_settings_tabs
          super + [
            { name: 'notifyme', partial: 'users/notifyme', label: 'label_notifyme' }
          ]
        end
      end
    end
  end
end

UsersHelper.prepend(Notifyme::Patches::UsersHelperPatch)
