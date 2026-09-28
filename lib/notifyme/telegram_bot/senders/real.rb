# frozen_string_literal: true

require 'imgkit'
require 'telegram/bot'

module Notifyme
  module TelegramBot
    module Senders
      class Real
        class << self
          def send_message(content_type, content, chat_ids)
            if content_type == :plain
              send_plain(content, chat_ids)
            elsif content_type == :html
              send_html(content, chat_ids)
            else
              raise "Unknown content type: \"#{data[:content_type]}\""
            end
          end

          protected

          def telegram_send_message(options)
            Bot.run do |bot|
              bot.api.sendMessage(options)
            end
          end

          def telegram_send_photo(options)
            Bot.run do |bot|
              bot.api.sendPhoto(options)
            end
          end

          private

          def send_plain(plain_text, chat_ids)
            chat_ids.each do |chat_id|
              telegram_send_message(chat_id: chat_id, text: plain_text)
            end
          end

          def send_html(html, chat_ids)
            file_id = nil
            chat_ids.each do |chat_id|
              if file_id
                send_photo_by_file_id(file_id, chat_id)
              else
                file_id = send_html_photo(html, chat_id).photo.last.file_id
              end
            end
          end

          def send_html_photo(html, chat_id = nil)
            on_html_image_file(html) do |photo_file|
              send_photo(photo_file, chat_id)
            end
          end

          def send_photo(photo, chat_id)
            photo = Faraday::UploadIO.new(File.expand_path(photo.to_s), nil) unless
            photo.is_a?(Faraday::UploadIO)
            telegram_send_photo(chat_id: chat_id, photo: photo)
          end

          def send_photo_by_file_id(file_id, chat_id)
            telegram_send_photo(chat_id: chat_id, photo: file_id)
          end

          require_sub __FILE__, require_mode: :kernel
        end
      end
    end
  end
end
