namespace :notifyme do
  namespace :git do
    desc 'Fetch all'
    task :reset, [:repository_id] => :environment do |_t, args|
      if args.repository_id.present?
        [Repository.find(args.repository_id)]
      else
        Repository.where(type: 'Repository::Xitolite')
      end.each do |r|
        Notifyme::Git::Repository.new(r).reset
      end
    end
  end
end
