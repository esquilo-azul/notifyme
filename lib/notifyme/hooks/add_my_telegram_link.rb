# frozen_string_literal: true

module Notifyme
  module Hooks
    class AddMyTelegramLink < Redmine::Hook::ViewListener
      def view_my_account_contextual(_context)
        link_to(sprite_icon('telegram', l(:label_telegram_preferences), plugin: 'notifyme'),
                telegram_preferences_path(User.current), class: 'icon icon-telegram')
      end
    end
  end
end
