# frozen_string_literal: true

class TelegramChat < ActiveRecord::Base
  belongs_to :user

  validates :chat_id, uniqueness: true

  def to_s
    "#{chat_name} (ID: #{chat_id}, Type: #{chat_type})"
  end
end
