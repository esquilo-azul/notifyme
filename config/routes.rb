RedmineApp::Application.routes.draw do
  resources(:telegram_chats) { as_routes }
end
