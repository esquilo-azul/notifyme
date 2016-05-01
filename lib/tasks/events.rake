namespace :notifyme do
  namespace :events do
    namespace :issue do
      desc 'Envia notificações da criação de um Issue'
      task :create, [:issue_id] => :environment do |_t, args|
        Notifyme::Events::Issue::Create.new(Issue.find(args.issue_id)).notify
      end

      desc 'Envia notificações da alteração de um Issue'
      task :update, [:journal_id] => :environment do |_t, args|
        Notifyme::Events::Issue::Update.new(Journal.find(args.journal_id)).notify
      end
    end
  end
end
