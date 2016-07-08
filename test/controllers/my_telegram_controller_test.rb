require 'test_helper'

class MyTelegramControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:chats)
  end
end
