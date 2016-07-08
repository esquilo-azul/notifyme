require 'telegram/bot'

module Notifyme
  module TelegramBot
    class Bot
      class << self
        def run
          Telegram::Bot::Client.run(Notifyme::Settings.telegram_bot_default_chat_id) do |bot|
            yield(bot)
          end
        end

        def send_message(messages, chat_id)
          messages = [messages] unless messages.is_a?(Array)
          run do |bot|
            messages.each do |message|
              bot.api.sendMessage(chat_id: chat_id, text: message)
            end
          end
        end

        def send_message_multiple_chat(messages, chat_ids)
          chat_ids.each do |chat_id|
            send_message(messages, chat_id)
          end
        end

        def send_html_photo(html, chat_id = nil)
          send_photo(html_to_image_file(html), chat_id)
        end

        def send_html_photo_multiple_chat(html, chat_ids)
          file_id = nil
          chat_ids.each do |chat_id|
            if file_id
              send_photo_by_file_id(file_id, chat_id)
            else
              r = send_html_photo(html, chat_id)
              file_id = r['result']['photo'][-1]['file_id'] if r['ok']
            end
          end
        end

        private

        def send_photo(photo, chat_id)
          photo = Faraday::UploadIO.new(File.expand_path(photo.to_s), nil) unless
          photo.is_a?(Faraday::UploadIO)
          run do |bot|
            bot.api.sendPhoto(chat_id: chat_id, photo: photo)
          end
        end

        def send_photo_by_file_id(file_id, chat_id)
          run do |bot|
            bot.api.sendPhoto(chat_id: chat_id, photo: file_id)
          end
        end

        def html_to_image_file(html)
          kit = IMGKit.new(html, quality: 50, width: 600)
          file = Tempfile.new(['development-helper-image', '.png'])
          Faraday::UploadIO.new(kit.to_file(file.path), nil)
        end
      end
    end
  end
end
