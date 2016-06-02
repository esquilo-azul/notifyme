module Notifyme
  module Events
    module Issue
      class Base
        include Notifyme::Html::Base
        include IssuesHelper
        include CustomFieldsHelper

        def initialize(event)
          @event = event
        end

        def run
          Notifyme::Notify.telegram(html)
        end

        private

        def template_file
          File.expand_path('../base.html.erb', __FILE__)
        end

        def title
          HTMLEntities.new.encode("#{issue.tracker.name} ##{issue.id}: #{issue.subject}", :named)
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
