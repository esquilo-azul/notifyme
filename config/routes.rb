RedmineApp::Application.routes.draw do
  resources(:telegram_chats) { as_routes }
  get '/my/telegram_preferences', to: 'telegram_preferences#index', as: 'telegram_preferences'
  put '/my/telegram_preferences', to: 'telegram_preferences#update'
end
