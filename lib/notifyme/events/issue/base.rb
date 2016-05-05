module Notifyme
  module Events
    module Issue
      class Base
        include ApplicationHelper
        include ActionView::Helpers::TagHelper
        include IssuesHelper
        include CustomFieldsHelper

        def initialize(event)
          @event = event
        end

        def run
          Notifyme::TelegramBot::Bot.new.send_html_photo(html)
        end

        private

        def html
          s = ''
          ERB.new(template_content, 0, '', 's').result(binding)
          s
        end

        def link_to(label, *_args)
          HTMLEntities.new.encode(label, :named)
        end

        def template_content
          File.read(File.expand_path('../base.html.erb', __FILE__))
        end

        def title
          HTMLEntities.new.encode("#{issue.tracker.name} ##{issue.id}: #{issue.subject}", :named)
        end

        def date
          issue.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        def author
          issue.author
        end

        def content
          Notifyme::Utils::HtmlEncode.encode(textilizable(issue, :description, only_path: false))
        end
      end
    end
  end
end
