class TelegramPreferencesController < ApplicationController
  before_filter :require_access_for_user, :build_chats

  helper :users

  def index
    @pref = @user.telegram_pref
  end

  def update
    @pref = UserTelegramPreference.new(pref_params)
    if @pref.save
      redirect_to telegram_preferences_path(@pref.user), notice: l(:notice_account_updated)
    else
      render :index
    end
  end

  private

  def build_chats
    @chats = TelegramChat.where(user: @user)
  end

  def pref_params
    r = params[::UserTelegramPreference.model_name.param_key]
        .permit(:no_self_notified, :issues, :git, issues_project_ids: [], git_project_ids: [])
        .merge(user: @user)
    r[:issues_project_ids] ||= []
    r[:git_project_ids] ||= []
    r
  end

  def require_access_for_user
    @user = User.find(params[:id])
    return unless require_login
    return true if User.current.admin? || User.current.id == @user.id
    render_403
    false
  end
end
