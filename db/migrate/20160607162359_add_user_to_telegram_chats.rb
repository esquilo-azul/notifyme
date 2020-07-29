# frozen_string_literal: true

class AddUserToTelegramChats < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    add_belongs_to :telegram_chats, :user
  end
end
