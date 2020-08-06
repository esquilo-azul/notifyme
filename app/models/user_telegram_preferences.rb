# frozen_string_literal: true

require_dependency 'concerns/user_preferences_model'

class UserTelegramPreferences
  include UserPreferencesModel

  PREFS = {
    no_self_notified: {
      get: 'false',
      set: 'value.present? && value != \'0\''
    },
    issues: {
      get: '\'only_my_events\'',
      set: 'value'
    },
    issues_project_ids: {
      get: '[]',
      set: 'value.select(&:present?).map(&:to_i)'
    },
    git: {
      get: '\'none\'',
      set: 'value'
    },
    git_project_ids: {
      get: '[]',
      set: 'value.select(&:present?).map(&:to_i)'
    }
  }.freeze

  class << self
    def issues_values
      ::User::MAIL_NOTIFICATION_OPTIONS.map(&:first)
    end

    def git_values
      %w[all selected none]
    end
  end

  validates :issues, presence: true, inclusion: { in: issues_values }

  PREFS.each do |k, v|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{k}
        pref_get(__method__, #{v[:get]})
      end

      def #{k}=(value)
        pref_set(__method__, #{v[:set]})
      end
    RUBY_EVAL
  end

  def issues_options
    raise 'Attribute "user" not set' if user.blank?

    user.valid_notification_options.collect { |o| [::I18n.t(o.last), o.first] }
  end

  def git_options
    issues_options.select { |o| self.class.git_values.include?(o.last) }
  end

  def preferences
    PREFS.keys
  end

  def preferences_key
    :telegram
  end
end
