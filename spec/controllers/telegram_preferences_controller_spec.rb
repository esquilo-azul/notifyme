# frozen_string_literal: true

require_relative 'user_preferences_shared_context'

describe TelegramPreferencesController, type: :feature do
  class << self
    # TO-DO: combinations for fields "issues_project_ids" and "git_project_ids"
    def data_combinations
      no_self_notified_data_combinations +
        issues_data_combinations +
        git_data_combinations
    end

    def no_self_notified_data_combinations
      [
        { no_self_notified: true },
        { no_self_notified: false }
      ]
    end

    # TO-DO: include "selected" option
    def issues_data_combinations
      (UserTelegramPreferences.issues_values - ['selected'])
        .map { |issue_value| { issues: issue_value } }
    end

    # TO-DO: include "selected" option
    def git_data_combinations
      (UserTelegramPreferences.git_values - ['selected'])
        .map { |git_value| { git: git_value } }
    end
  end

  include_context('with user preferences') do
    let(:model_class) { UserTelegramPreferences }
    let(:user_pref_method) { :telegram_pref }
    let(:index_path) { "/users/#{User.current.id}/telegram_preferences" }
    let(:no_self_notified_input_type) { :checkbox }
    let(:issues_input_type) { :select }
    let(:git_input_type) { :select }
  end
end
