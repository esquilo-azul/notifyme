# frozen_string_literal: true

require_dependency 'concerns/user_preferences_controller'

class TelegramPreferencesController < ApplicationController
  include ::UserPreferencesController

  before_action :build_chats

  helper :users

  private

  def build_chats
    @chats = TelegramChat.where(user: @user)
  end

  def pref_params
    r = params[model_class.model_name.param_key]
        .permit(:no_self_notified, :issues, :git, issues_project_ids: [], git_project_ids: [])
    r[:issues_project_ids] ||= []
    r[:git_project_ids] ||= []
    r
  end
end
