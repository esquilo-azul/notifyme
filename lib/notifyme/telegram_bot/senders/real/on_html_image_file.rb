# frozen_string_literal: true

require 'imgkit'

module Notifyme
  module TelegramBot
    module Senders
      class Real
        class OnHtmlImageFile
          acts_as_static_method
          common_constructor :sender, :html, :block, block_arg: true

          # @return [Faraday::UploadIO]
          def result
            on_temp_image_file do
              block.call(faraday_upload_io)
            end
          end

          protected

          # @!attribute [rw] temp_image_file
          #   @return [Pathname]
          attr_accessor :temp_image_file

          # @return [Faraday::UploadIO]
          def faraday_upload_io
            ::Faraday::UploadIO.new(html_to_image_file, nil)
          end

          # @return [Pathname]
          def html_to_image_file
            image_kit.to_file(temp_image_file)
          end

          # @return [IMGKit]
          def image_kit
            IMGKit.new(html, quality: 50, width: 600, crop_h: 1200)
          end

          # @return [Object]
          def on_temp_image_file
            ::EacRubyUtils::Fs::Temp.on_file(['development-helper-image', '.png']) do |temp_file|
              self.temp_image_file = temp_file.to_pathname
              yield
            end
          end
        end
      end
    end
  end
end
