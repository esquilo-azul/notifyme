module Notifyme
  module Hooks
    class AddMyTelegramLink < Redmine::Hook::ViewListener
      def view_my_account_contextual(_context)
        link_to(l(:label_my_telegram), telegram_preferences_path, class: 'icon icon-telegram')
      end
    end
  end
end
