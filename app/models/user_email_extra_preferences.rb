# frozen_string_literal: true

class UserEmailExtraPreferences
  include Notifyme::UserPreferencesModelConcern

  validates :assignee_reminder, inclusion: { in: [true, false] }

  def assignee_reminder
    pref_get(__method__, false)
  end

  def assignee_reminder=(value)
    pref_set(__method__.to_s.gsub(/=\z/, ''), value ? true : false)
  end

  def preferences
    %w[assignee_reminder]
  end

  def preferences_key
    :email_extra
  end
end
