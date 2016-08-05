Rails.application.routes.draw do

  root 'welcome#index'

  get '/submit', to: 'submit#show'
  get '/view_item/:id', to: 'view_item#show'
end
