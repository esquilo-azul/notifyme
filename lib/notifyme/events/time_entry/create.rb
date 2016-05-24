module Notifyme
  module Events
    module TimeEntry
      class Create
        include Notifyme::Html::Base
        include ActionView::Helpers::NumberHelper

        def initialize(event)
          @event = event
        end

        def run
          Notifyme::TelegramBot::Bot.new.send_html_photo(html)
        end

        private

        def template_file
          File.expand_path('../create.html.erb', __FILE__)
        end

        def time_entry
          @event.data
        end

        def date
          time_entry.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        def author
          time_entry.user
        end

        def format_number(n)
          number_with_precision(n, precision: 2)
        end

        def l_hours(hours)
          l((hours < 2.0 ? :label_f_hour : :label_f_hour_plural), value: format_number(hours))
        end
      end
    end
  end
end
