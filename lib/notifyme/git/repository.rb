module Notifyme
  module Git
    class Repository
      include ::Notifyme::Git::Repository::OldNewBranches
      include ::Notifyme::Git::Repository::Reset
      include ::Notifyme::Git::Repository::Notify
      attr_reader :repository

      def initialize(repository)
        @repository = repository
      end

      private

      def cache_branches
        RepositoryBranch.where(repository: repository)
      end

      def to_s
        "[#{repository.type}] #{repository.url}"
      end
    end
  end
end
