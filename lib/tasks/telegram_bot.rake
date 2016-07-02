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

    desc 'Envia uma imagem para um chat Teleegram'
    task :send_photo, [:photo_file, :chat_id] => :environment do |_t, args|
      Notifyme::TelegramBot::Bot.new.send_photo(args.photo_file, args.chat_id)
    end

    desc 'Converte um HTML para imagem e envia para um chat Telegram'
    task :send_html, [:html, :chat_id] => :environment do |_t, args|
      Notifyme::TelegramBot::Bot.new.send_html_photo(args.html, args.chat_id)
    end

    desc 'Converte um HTML para imagem e envia para todos os chats vinculados'
    task :notify_html, [:html] => :environment do |_t, args|
      Notifyme::Notify.telegram_html(args.html)
    end
  end
end
