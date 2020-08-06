# frozen_string_literal: true

module Notifyme
  module Patches
    module UsersHelperPatch
      def self.included(base)
        require_dependency 'users_helper'
        base.include(InstanceMethods)
        base.class_eval do
          alias_method_chain :user_settings_tabs, :notifyme
        end
      end

      module InstanceMethods
        def user_settings_tabs_with_notifyme
          user_settings_tabs_without_notifyme + [
            { name: 'notifyme', partial: 'users/notifyme', label: 'label_notifyme' }
          ]
        end
      end
    end
  end
end

source = ::Notifyme::Patches::UsersHelperPatch
target = ::UsersHelper
target.send(:include, source) unless target.included_modules.include? source
