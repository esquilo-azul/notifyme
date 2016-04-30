namespace :notifyme do
  namespace :telegram_bot do
    desc 'Lê continuamente e processa mensagens recebidas pelo Telegram'
    task message_listener: :environment do
      Notifyme::TelegramBot::MessageListener.new.run
    end
  end
end
