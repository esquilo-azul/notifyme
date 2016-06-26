module Notifyme
  module Html
    module Base
      include ApplicationHelper
      include ActionView::Helpers::TagHelper

      def html
        assets_content << template_content
      end

      private

      def template_content
        s = ''
        ERB.new(File.read(template_file), 0, '', 's').result(binding)
        Notifyme::Utils::HtmlEncode.encode(s)
      end

      def link_to(label, *_args)
        HTMLEntities.new.encode(label, :named)
      end

      def assets_directory
        File.expand_path('../assets', __FILE__)
      end

      def assets_content
        b = ''
        Dir.glob("#{assets_directory}/*.css") do |css_file|
          b << css_content(css_file)
        end
        b
      end

      def css_content(css_file)
        "<style>\n#{Notifyme::Utils::HtmlEncode.encode(File.read(css_file))}</style>\n"
      end

      def download_named_attachment_url(_attachment, name, _options = {})
        Notifyme::Utils::HtmlEncode.encode(link_to(name))
      end

      def url_for(*_args)
        ''
      end

      def issue_url(issue, _options = {})
        link_to("\##{issue.id}")
      end
    end
  end
end
