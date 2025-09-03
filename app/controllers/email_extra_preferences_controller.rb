# frozen_string_literal: true

require_dependency 'concerns/user_preferences_controller'

class EmailExtraPreferencesController < ApplicationController
  include ::UserPreferencesController

  private

  def pref_params
    r = params[model_class.model_name.param_key].permit(:assignee_reminder)
    r[:assignee_reminder] = sanitize_boolean(r[:assignee_reminder])
    r
  end

  def sanitize_boolean(value) # rubocop:disable Naming/PredicateMethod
    return false if value.blank?
    return false if %w[0 false].include?(value.to_s.strip)

    true
  end
end
