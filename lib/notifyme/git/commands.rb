# frozen_string_literal: true

module Notifyme
  module Git
    class Commands
      class << self
        def descendant?(repository, descendant, ancestor)
          base = merge_base(repository, descendant, ancestor)
          return false if base.blank?

          revparse = repository.git_cmd(['rev-parse', '--verify', ancestor]).strip
          base == revparse
        end

        def merge_base(repository, *commits)
          refs = commits.dup
          while refs.count > 1
            refs[1] = merge_base_pair(repository, refs[0], refs[1])
            return nil if refs[1].blank?

            refs.shift
          end
          refs.first
        end

        def merge_base_pair(repository, reference1, reference2)
          repository.git_cmd(['merge-base', reference1, reference2]).strip
        rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted => e
          return nil if e.message.start_with?('Git exited with non-zero status : 1')

          raise e
        end

        def parents(repository, commit)
          revs = repository.git_cmd(['rev-list', '--parents', '-n', '1', commit]).split(/\s/)
          revs.shift
          revs
        end
      end
    end
  end
end
