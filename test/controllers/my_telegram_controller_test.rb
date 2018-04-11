require 'test_helper'

class MyTelegramControllerTest < ActionController::TestCase
  fixtures :users, :projects

  setup do
    @controller.logged_user = ::User.find(1) # admin
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:chats)
    assert_not_nil assigns(:pref)
  end

  def test_update
    [false, true].each do |no_self_notified|
      issues_values.each do |issues|
        [[], [::Project.first.id]].each do |issues_project_ids|
          assert_update_issues(no_self_notified, issues, issues_project_ids)
        end
      end
    end
  end

  def assert_update_issues(no_self_notified, issues, issues_project_ids)
    put :update, user_telegram_preference: { no_self_notified: no_self_notified ? '1' : '0',
                                             issues: issues,
                                             issues_project_ids: issues_project_ids }
    assert_redirected_to '/my/telegram'
    assert_equal no_self_notified, User.current.telegram_pref.no_self_notified
    assert_equal issues, User.current.telegram_pref.issues
    assert_equal issues_project_ids, User.current.telegram_pref.issues_project_ids
  end
end
