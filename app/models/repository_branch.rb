# frozen_string_literal: true

class RepositoryBranch < ActiveRecord::Base
  belongs_to :repository

  validates :repository, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :name, presence: true, uniqueness: { scope: [:repository] } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :revision, presence: true

  def to_s
    "[#{repository.type}|#{repository.url}|#{name}]"
  end

  def to_redmine_git_hosting
    b = Redmine::Scm::Adapters::XitoliteAdapter::GitBranch.new(name)
    b.revision = revision
    b.scmid = revision
    b.is_default = false
    b
  end
end
