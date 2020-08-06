# frozen_string_literal: true

module Notifyme
  module Hooks
    class AddMyTelegramLink < Redmine::Hook::ViewListener
      def view_my_account_contextual(_context)
        link_to(l(:label_telegram_preferences), telegram_preferences_path(User.current),
                class: 'icon icon-telegram')
      end
    end
  end
end
