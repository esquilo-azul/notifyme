# frozen_string_literal: true

require 'imgkit'

IMGKit.configure do |config|
  config.wkhtmltoimage = '/usr/bin/wkhtmltoimage'
end
