RedmineApp::Application.routes.draw do
  resources(:telegram_chats) { as_routes }
  get '/users/:id/email_extra_preferences', to: 'email_extra_preferences#index',
                                            as: 'email_extra_preferences'
  put '/users/:id/email_extra_preferences', to: 'email_extra_preferences#update'
  get '/users/:id/telegram_preferences', to: 'telegram_preferences#index',
                                         as: 'telegram_preferences'
  put '/users/:id/telegram_preferences', to: 'telegram_preferences#update'
end
