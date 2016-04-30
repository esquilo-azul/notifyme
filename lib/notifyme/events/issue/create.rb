module Notifyme
  module Events
    module Issue
      class Create
        include ApplicationHelper
        include IssuesHelper
        include CustomFieldsHelper
        include ActionView::Helpers::TagHelper
        attr_reader :issue

        def initialize(issue)
          @issue = issue
        end

        def notify
          Notifyme::TelegramBot::Bot.new.send_html_photo(html)
        rescue => ex
          Rails.logger.warn(ex)
        end

        def html
          s = ''
          ERB.new(template_content, 0, '', 's').result(binding)
          s
        end

        private

        def template_content
          File.read(File.expand_path('../create.html.erb', __FILE__))
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

        def attributes
          Notifyme::Utils::HtmlEncode.encode(render_email_issue_attributes(issue, nil, true).to_s)
        end
      end
    end
  end
end
