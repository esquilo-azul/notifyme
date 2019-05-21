class UserTelegramPreferences
  include ActiveModel::Model

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
      %w(all selected none)
    end
  end

  attr_accessor :user

  validates :issues, presence: true, inclusion: { in: issues_values }

  PREFS.each do |k, v|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{k}
        telegram_pref_get(__method__, #{v[:get]})
      end

      def #{k}=(value)
        telegram_pref_set(__method__, #{v[:set]})
      end
    RUBY_EVAL
  end

  def issues_options
    raise 'Attribute "user" not set' unless user.present?
    user.valid_notification_options.collect { |o| [::I18n.t(o.last), o.first] }
  end

  def git_options
    issues_options.select { |o| self.class.git_values.include?(o.last) }
  end

  def save
    user.pref[:telegram] = Hash[PREFS.keys.map { |k| [k, send(k)] }]
    user.pref.save!
  end

  private

  def telegram_pref_get(name, default_value)
    data[name].nil? ? telegram_user_pref_get(name, default_value) : data[name]
  end

  def telegram_user_pref_get(name, default_value)
    raise 'Attribute "user" is blank' if user.blank?
    if user.pref[:telegram] && user.pref[:telegram][name]
      user.pref[:telegram][name]
    else
      default_value
    end
  end

  def telegram_pref_set(name, value)
    data[name.to_s.gsub(/[^a-z_0-9]+\z/i, '')] = value
  end

  def data
    @data ||= {}.with_indifferent_access
  end
end
