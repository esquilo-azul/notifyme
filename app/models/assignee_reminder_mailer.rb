# frozen_string_literal: true

class AssigneeReminderMailer < ::Mailer
  helper ::QueriesHelper
  helper ::NotifymeMailerHelper

  class << self
    def remind_all_users
      ::Rails.logger.info "Users to remind: #{users_to_remind.count}"
      users_to_remind.each do |user|
        remind_user(user)
      end
    end

    private

    def users_to_remind
      @users_to_remind ||= ::User.active.select { |user| user.email_extra_pref.assignee_reminder }
    end

    def remind_user(user)
      ::Rails.logger.info "  * Reminding user \"#{user}\"..."
      ::AssigneeReminderMailer.remind(user).deliver
    end
  end

  def remind(user)
    raise "Argument \"user\" is not a User: #{user}" unless user.is_a?(::User)

    ::Rails.logger.info "Sending to #{user}"
    @subject = "Relatório de atribuições de #{user}"
    @query = build_query(user)
    @issues = @query.issues
    mail(to: user, subject: @subject)
  end

  private

  def build_query(user)
    query = ::Notifyme::Settings.assignee_reminder_query
    query.filters['assigned_to_id'] ||= {}
    query.filters['assigned_to_id'] = { operator: '=', values: [user.id] }
    query
  end
end
