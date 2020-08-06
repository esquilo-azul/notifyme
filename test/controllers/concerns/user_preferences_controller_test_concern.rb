# frozen_string_literal: true

require 'test_helper'

module UserPreferencesControllerTestBase
  extend ActiveSupport::Concern

  included do
    fixtures :users, :projects

    setup do
      log_user('jsmith', 'jsmith')
    end
  end

  def test_index
    get my_index_path
    assert_on_index
  end

  def test_update
    all_put_combinations(put_combinations).each do |data|
      assert_update(data)
    end
  end

  private

  def all_put_combinations(left) # rubocop:disable Metrics/MethodLength
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
    put my_index_path, model_class.model_name.param_key => params_to_put(data)
    assert_redirected_to my_index_path
    assert_user_updated(data)
    follow_redirect!
  end

  def assert_on_index
    assert_template 'index'
    assert_not_nil assigns(:pref)
  end

  def params_to_put(data)
    data.dup
  end

  def assert_user_updated(data)
    data.each do |key, expected|
      assert_equal expected, User.current.send(user_pref_method).send(key), key
    end
  end
end
