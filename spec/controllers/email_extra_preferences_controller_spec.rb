# frozen_string_literal: true

require_relative 'user_preferences_shared_context'

describe ::EmailExtraPreferencesController, type: :feature do
  class << self
    def data_combinations
      [
        { assignee_reminder: false },
        { assignee_reminder: true }
      ]
    end
  end

  include_context('with user preferences') do
    let(:model_class) { ::UserEmailExtraPreferences }
    let(:user_pref_method) { :email_extra_pref }
    let(:index_path) { "/users/#{user_id}/email_extra_preferences" }
    let(:assignee_reminder_input_type) { :checkbox }
  end
end
