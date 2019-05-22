# frozen_string_literal: true

module NotifymeMailerHelper
  def column_value(column, item, value)
    case column.name
    when :id
      link_to value, issue_url(item)
    when :subject
      link_to value, issue_url(item)
    when :parent
      value ? (value.visible? ? link_to_issue(value, subject: false) : "##{value.id}") : ''
    when :description
      item.description? ? content_tag('div', textilizable(item, :description), class: 'wiki') : ''
    when :last_notes
      item.last_notes.present? ? content_tag('div', textilizable(item, :last_notes), class: 'wiki') : ''
    when :done_ratio
      progress_bar(value)
    when :relations
      content_tag('span',
                  value.to_s(item) { |other| link_to_issue(other, subject: false, tracker: false) }.html_safe,
                  class: value.css_classes_for(item))
    when :hours, :estimated_hours
      format_hours(value)
    when :spent_hours
      link_to_if(value > 0, format_hours(value), project_time_entries_url(item.project, issue_id: item.id.to_s))
    when :total_spent_hours
      link_to_if(value > 0, format_hours(value), project_time_entries_url(item.project, issue_id: "~#{item.id}"))
    when :attachments
      value.to_a.map { |a| format_object(a) }.join(' ').html_safe
    else
      format_object(value)
    end
  end

  def link_to_project(project, options = {}, html_options = nil)
    super project, { only_path: false }.merge(options), html_options
  end

  def user_path(user)
    user_url(user)
  end

  def version_path(version)
    version_url(version)
  end
end
