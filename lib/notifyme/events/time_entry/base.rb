# frozen_string_literal: true

module Notifyme
  module Events
    module TimeEntry
      class Base
        include Notifyme::Html::Base
        include ByActivity
        include ActionView::Helpers::NumberHelper

        def initialize(event)
          @event = event
        end

        def run
          Notifyme::Notify.notify(content_type: :html, content: html, author: author,
                                  source: time_entry.issue)
        end

        private

        def template_file
          File.expand_path('base.html.erb', __dir__)
        end

        def date
          time_entry.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        def author
          time_entry.user
        end

        def hours_added_text
          hours_added.map { |t| hour_added(t) }.join(', ')
        end

        def hour_added(entry)
          "<span class='#{hour_added_css_class(entry)}'>#{hour_added_text(entry)}</span>"
        end

        def hour_added_css_class(entry)
          'hours_' + (entry[:add] ? 'add' : 'sub')
        end

        def hour_added_text(entry)
          (entry[:add] ? '+' : '-') << l_hours(entry[:hours])
        end

        def format_number(number)
          number_with_precision(number, precision: 2)
        end

        def l_hours(hours)
          l((hours < 2.0 ? :label_f_hour : :label_f_hour_plural), value: format_number(hours))
        end
      end
    end
  end
end
