module Notifyme
  module Git
    class Repository
      module Notify
        def notify(reset)
          telegram_notify
          self.reset if reset
        end

        def telegram_notify
          old_new_branches.each do |onb|
            if onb.change?
              Rails.logger.debug("#{onb}: changed")
              bot.send_html_photo(onb.html_graph)
            else
              Rails.logger.debug("#{onb}: not changed")
            end
          end
        end

        private

        def bot
          @bot ||= Notifyme::TelegramBot::Bot.new
        end
      end
    end
  end
end
