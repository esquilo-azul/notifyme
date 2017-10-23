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
      ::User::MAIL_NOTIFICATION_OPTIONS.map(&:first).each do |filter|
        [[], [::Project.first.id]].each do |filter_project_ids|
          assert_update_filter(no_self_notified, filter, filter_project_ids)
        end
      end
    end
  end

  def assert_update_filter(no_self_notified, filter, filter_project_ids)
    put :update, user_telegram_preference: { no_self_notified: no_self_notified ? '1' : '0',
                                             filter: filter,
                                             filter_project_ids: filter_project_ids }
    assert_redirected_to '/my/telegram'
    assert_equal no_self_notified, User.current.telegram_pref.no_self_notified
    assert_equal filter, User.current.telegram_pref.filter
    assert_equal filter_project_ids, User.current.telegram_pref.filter_project_ids
  end
end
