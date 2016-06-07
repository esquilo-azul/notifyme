module Notifyme
  module TelegramBot
    module Commands
      class Echo
        def run(bot, message, args)
          text = args.join(' ').strip
          bot.api.sendMessage(chat_id: message.chat.id, text: text) unless text.empty?
        end
      end
    end
  end
end
