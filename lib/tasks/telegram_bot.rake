# frozen_string_literal: true

namespace :notifyme do
  namespace :telegram_bot do
    desc 'Lê continuamente e processa mensagens recebidas pelo Telegram'
    task message_listener: :environment do
      Notifyme::TelegramBot::MessageListener.new.run
    end

    desc 'Envia uma mensagem para um chat Telegram'
    task :send_plain, %i[message chat_id] => :environment do |_t, args|
      Notifyme::TelegramBot::Bot.send_message(:plain, args.message, [args.chat_id])
    end

    desc 'Converte um HTML para imagem e envia para um chat Telegram'
    task :send_html, %i[html chat_id] => :environment do |_t, args|
      Notifyme::TelegramBot::Bot.send_message(:html, args.html, [args.chat_id])
    end
  end
end
