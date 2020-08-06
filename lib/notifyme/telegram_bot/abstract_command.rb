# frozen_string_literal: true

module Notifyme
  module TelegramBot
    module AbstractCommand
      attr_accessor :bot, :message, :args
    end
  end
end
