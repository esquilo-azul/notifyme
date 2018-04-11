class UserTelegramPreference
  include ActiveModel::Model

  PREFS = %i(no_self_notified filter filter_project_ids).freeze

  attr_accessor :user

  validates :filter, presence: true, inclusion: {
    in: ::User::MAIL_NOTIFICATION_OPTIONS.map { |v| v[0] }
  }

  def save
    user.pref[:telegram] = Hash[PREFS.map { |k| [k, send(k)] }]
    user.pref.save!
  end

  def no_self_notified
    telegram_pref_get(__method__, false)
  end

  def no_self_notified=(value)
    telegram_pref_set(__method__, value.present? && value != '0')
  end

  def filter
    telegram_pref_get(__method__, 'only_my_events')
  end

  def filter=(value)
    telegram_pref_set(__method__, value)
  end

  def filter_project_ids
    telegram_pref_get(__method__, [])
  end

  def filter_project_ids=(value)
    telegram_pref_set(__method__, value.select(&:present?).map(&:to_i))
  end

  private

  def telegram_pref_get(name, default_value)
    data[name].nil? ? telegram_user_pref_get(name, default_value) : data[name]
  end

  def telegram_user_pref_get(name, default_value)
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
