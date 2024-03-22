# frozen_string_literal: true

require 'telegram/bot'
require 'shellwords'

module Notifyme
  module TelegramBot
    class CommandFactory
      def self.process_message(bot, message)
        command_name, args = parse_message(message)
        run_command(bot, message, command_name, args)
      rescue SystemExit => e
        raise e
      rescue StandardError => e
        Rails.logger.warn e
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{e.class}: \"#{e}\"")
      end

      def self.parse_message(message)
        return [nil, nil] unless message&.text

        match = %r{^/(\S+)(?:\s(.+))*}.match(message.text.strip)
        if match
          parse_command(match[1..-1].join(' ').strip) # rubocop:disable Style/SlicingWithRange
        else
          [nil, nil]
        end
      end

      def self.run_command(bot, message, command_name, args)
        return unless command_name

        command = find_command(command_name, bot, message, args)
        if command
          command.run
        else
          bot.api.sendMessage(chat_id: message.chat.id,
                              text: "Comando não encontrado: \"#{command_name}\"")
        end
      end

      def self.parse_command(command_line)
        args = Shellwords.split(command_line)
        [args[0], args[1..-1]] # rubocop:disable Style/SlicingWithRange
      end

      def self.find_command(command_name, bot, message, args)
        klass = command_class(command_name)
        return nil unless klass

        obj = klass.new
        obj.bot = bot
        obj.message = message
        obj.args = args
        obj
      end

      def self.command_class(command_name)
        c = Object.const_get(:Notifyme).const_get(:TelegramBot).const_get(:Commands).const_get(
          ActiveSupport::Inflector.camelize(command_name)
        )
        c.is_a?(Class) ? c : nil
      rescue NameError
        nil
      end

      def self.commands
        Dir[File.expand_path('commands/*.rb', __dir__)].map do |file|
          File.basename(file, '.rb')
        end
      end
    end
  end
end
