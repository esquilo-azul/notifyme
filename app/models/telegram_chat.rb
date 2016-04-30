class TelegramChat < ActiveRecord::Base
  def to_s
    "#{chat_name} (ID: #{chat_id}, Type: #{chat_type})"
  end
end
