namespace :notifyme do
  namespace :telegram_bot do
    desc 'Lê continuamente e processa mensagens recebidas pelo Telegram'
    task message_listener: :environment do
      Notifyme::TelegramBot::MessageListener.new.run
    end

    desc 'Envia uma mensagem para um chat Telegram'
    task :send_message, [:message, :chat_id] => :environment do |_t, args|
      Notifyme::TelegramBot::Bot.new.send_message(args.message, args.chat_id)
    end
  end
end
