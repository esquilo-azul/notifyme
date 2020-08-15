# frozen_string_literal: true

module Notifyme
  module Events
    module TimeEntry
      class Base
        module ByActivity
          def activity_table
            content_tag(:table, class: 'activity') do
              header + body
            end
          end

          def header
            content_tag(:thead) do
              b = ActiveSupport::SafeBuffer.new
              b += content_tag(:th, 'Tópico')
              activities.each do |a|
                b += content_tag(:th, a)
              end
              b += content_tag(:th, 'Total')
              b
            end
          end

          def body
            content_tag(:tbody) do
              b = ActiveSupport::SafeBuffer.new
              subjects.each { |k, v| b += subject_row(k, v) }
              b
            end
          end

          def subjects
            { issue: "##{time_entry.issue.id}",
              user_issue: "##{time_entry.issue.id} && #{time_entry.user.firstname}",
              user: "#{time_entry.user.firstname} (24hs)" }
          end

          def subject_row(type, column_header_label)
            content_tag(:tr) do
              total = 0
              b = content_tag(:th, column_header_label)
              activities.each do |activity|
                hours = subject_hours(type, activity)
                b += content_tag(:td, format_number(hours))
                total += hours
              end
              b += content_tag(:td, format_number(total))
            end
          end

          def subject_hours(type, activity)
            send("subject_hours_#{type}", activity)
          end

          def subject_hours_issue(activity)
            ::TimeEntry.where(issue: time_entry.issue, activity: activity).sum(:hours)
          end

          def subject_hours_user_issue(activity)
            ::TimeEntry.where(user: time_entry.user, issue: time_entry.issue, activity: activity)
                       .sum(:hours)
          end

          def subject_hours_user(activity)
            ::TimeEntry.where(user: time_entry.user, activity: activity)
                       .where('created_on > ?', 24.hours.ago)
                       .sum(:hours)
          end

          def activities
            TimeEntryActivity.all
          end

          def output_buffer=(buffer)
            @b = buffer
          end

          def output_buffer
            @b
          end
        end
      end
    end
  end
end
