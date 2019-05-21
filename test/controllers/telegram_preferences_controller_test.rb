# frozen_string_literal: true

require_relative 'concerns/user_preferences_controller_test_concern'

class TelegramPreferencesControllerTest < Redmine::IntegrationTest
  include ::UserPreferencesControllerTestBase

  private

  def put_combinations
    [
      [:no_self_notified, [false, true]],
      [:issues, ::UserTelegramPreferences.issues_values],
      [:issues_project_ids, [[], [::Project.first.id]]],
      [:git, ::UserTelegramPreferences.git_values],
      [:git_project_ids, [[], [::Project.first.id]]]
    ]
  end

  def model_class
    ::UserTelegramPreferences
  end

  def my_index_path
    "/users/#{User.current.id}/telegram_preferences"
  end

  def user_pref_method
    :telegram_pref
  end

  def assert_on_index
    super
    assert_not_nil assigns(:chats)
  end

  def params_to_put(data)
    r = super
    r[:no_self_notified] = r[:no_self_notified] ? '1' : '0'
    r
  end
end
