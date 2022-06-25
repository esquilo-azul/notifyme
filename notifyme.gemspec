# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'notifyme/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'notifyme'
  s.version     = ::Notifyme::VERSION
  s.authors     = [::Notifyme::VERSION]
  s.summary     = ::Notifyme::SUMMARY
  s.homepage    = ::Notifyme::HOMEPAGE

  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files spec test`.split("\n")

  s.add_dependency 'eac_ruby_utils', '~> 0.46'
  s.add_dependency 'htmlentities'
  s.add_dependency 'imgkit'
  s.add_dependency 'telegram-bot-ruby'
  s.add_dependency 'wkhtmltoimage-binary'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
