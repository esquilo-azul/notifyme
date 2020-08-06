# frozen_string_literal: true

module UserPreferencesController
  extend ActiveSupport::Concern

  included do
    before_action :require_access_for_user
  end

  def index
    @pref = @user.send("#{preference_key}_pref")
  end

  def update
    @pref = model_class.new(pref_params.merge(user: @user))
    if @pref.save
      redirect_to index_path(@pref.user), notice: l(:notice_account_updated)
    else
      render :index
    end
  end

  def require_access_for_user
    @user = User.find(params[:id])
    return unless require_login
    return true if User.current.admin? || User.current.id == @user.id

    render_403
    false
  end

  private

  def index_path(user)
    send("#{preference_key}_preferences_path", user)
  end

  def preference_key
    self.class.name.gsub(/PreferencesController\z/, '').underscore
  end

  def model_class
    "user_#{preference_key}_preferences".camelize.constantize
  end
end
