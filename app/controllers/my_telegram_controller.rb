class MyTelegramController < ApplicationController
  before_filter :require_login

  def index
    @chats = TelegramChat.where(user: User.current)
  end
end
