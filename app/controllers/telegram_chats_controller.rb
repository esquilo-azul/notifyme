class TelegramChatsController < ApplicationController
  layout 'admin_active_scaffold'
  before_filter :require_admin

  active_scaffold :telegram_chat do |conf|
    conf.list.columns << :chat_id
    conf.show.columns << :chat_id
    conf.actions.exclude :create, :update, :delete
  end
end
