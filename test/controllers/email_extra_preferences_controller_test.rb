# frozen_string_literal: true

require_relative 'concerns/user_preferences_controller_test_concern'

class EmailExtraPreferencesControllerTest < Redmine::IntegrationTest
  include ::UserPreferencesControllerTestBase

  private

  def put_combinations
    [
      [:assignee_reminder, [false, true]]
    ]
  end

  def model_class
    ::UserEmailExtraPreferences
  end

  def my_index_path
    "/users/#{User.current.id}/email_extra_preferences"
  end

  def user_pref_method
    :email_extra_pref
  end
end
