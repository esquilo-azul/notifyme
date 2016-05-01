module Notifyme
  module Events
    module Issue
      class Create < Base
        attr_reader :issue

        def initialize(issue)
          @issue = issue
        end

        def date
          issue.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        delegate :author, to: :issue

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
