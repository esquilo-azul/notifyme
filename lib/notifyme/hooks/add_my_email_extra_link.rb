# frozen_string_literal: true

module Notifyme
  module Hooks
    class AddMyEmailExtraLink < Redmine::Hook::ViewListener
      def view_my_account_contextual(_context)
        link_to(l(:label_email_extra_preferences), email_extra_preferences_path(User.current),
                class: 'icon icon-email')
      end
    end
  end
end
