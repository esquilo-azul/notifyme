# frozen_string_literal: true

module UserPreferencesModel
  extend ::ActiveSupport::Concern

  included do
    include ::ActiveModel::Model
    validates :user, presence: true
  end

  attr_accessor :user

  def save
    return false unless valid?

    user.pref[preferences_key] = Hash[preferences.map { |k| [k.to_sym, send(k)] }]
    user.pref.save!
  end

  private

  def user_pref_get(name, default_value)
    raise 'Attribute "user" is blank' if user.blank?

    p = user.pref[preferences_key]
    p && p[name.to_sym] ? p[name.to_sym] : default_value
  end

  def pref_get(name, default_value)
    data[name].nil? ? user_pref_get(name, default_value) : data[name]
  end

  def pref_set(name, value)
    data[name.to_s.gsub(/[^a-z_0-9]+\z/i, '')] = value
  end

  def data
    @data ||= {}.with_indifferent_access
  end
end
