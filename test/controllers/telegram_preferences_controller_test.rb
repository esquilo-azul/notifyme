require 'test_helper'

class TelegramPreferencesControllerTest < Redmine::IntegrationTest
  fixtures :users, :projects

  setup do
    log_user('jsmith', 'jsmith')
  end

  def test_index
    get my_telegram_path
    assert_on_index
  end

  def test_update
    all_put_combinations(put_combinations).each do |data|
      assert_update(data)
    end
  end

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

  def all_put_combinations(left)
    x = left.pop
    return [] unless x
    self_combs = x.last.map { |v| { x.first => v } }
    sub_combs = all_put_combinations(left)
    return self_combs unless sub_combs.any?
    r = []
    sub_combs.each do |sub_comb|
      self_combs.each do |self_comb|
        r << sub_comb.merge(self_comb)
      end
    end
    r
  end

  def assert_update(data)
    put my_telegram_path, ::UserTelegramPreferences.model_name.param_key => params_to_put(data)
    assert_redirected_to my_telegram_path
    assert_user_updated(data)
    follow_redirect!
  end

  def assert_on_index
    assert_template 'index'
    assert_not_nil assigns(:chats)
    assert_not_nil assigns(:pref)
  end

  def params_to_put(data)
    r = data.dup
    r[:no_self_notified] = r[:no_self_notified] ? '1' : '0'
    r
  end

  def assert_user_updated(data)
    data.each do |key, expected|
      assert_equal expected, User.current.telegram_pref.send(key), key
    end
  end

  def my_telegram_path
    "/users/#{User.current.id}/telegram_preferences"
  end
end
