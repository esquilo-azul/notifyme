# frozen_string_literal: true

module Notifyme
  module Patches
    module User
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.has_many :telegram_chats
      end

      module InstanceMethods
        def email_extra_pref
          @email_extra_pref ||= UserEmailExtraPreferences.new(user: self)
        end

        def telegram_pref
          @telegram_pref ||= UserTelegramPreferences.new(user: self)
        end
      end
    end
  end
end
