module Notifyme
  module Patches
    module RepositoryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def branch_revision(branch_name)
          check_git_repository
          return nil unless branches
          b = branches.find { |x| x.to_s == branch_name }
          b ? b.revision : nil
        end

        def git_cmd(args)
          s = ''
          scm.send('git_cmd', args) do |io|
            s = io.read
          end
          s
        end

        private

        def check_git_repository
          raise 'Not a git repository' unless is_a?(Repository::Git)
        end
      end
    end
  end
end

unless Repository.included_modules.include? Notifyme::Patches::RepositoryPatch
  Repository.send(:include, Notifyme::Patches::RepositoryPatch)
end
