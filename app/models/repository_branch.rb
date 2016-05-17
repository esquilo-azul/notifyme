class RepositoryBranch < ActiveRecord::Base
  belongs_to :repository

  validates :repository, presence: true
  validates :name, presence: true, uniqueness: { scope: [:repository] }
  validates :revision, presence: true

  def to_s
    "[#{repository.type}|#{repository.url}|#{name}]"
  end
end
