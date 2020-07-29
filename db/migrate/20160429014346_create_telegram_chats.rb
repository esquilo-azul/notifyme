# frozen_string_literal: true

class CreateTelegramChats < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :telegram_chats do |t|
      t.integer :chat_id
      t.string :chat_name
      t.string :chat_type

      t.timestamps null: false
    end
  end
end
