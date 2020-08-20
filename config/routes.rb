Rails.application.routes.draw do
  root to: 'main#index'

  namespace 'api' do		
    post '/users' => 'users#create', :path => 'create-user'
    #post '/sessions' => 'sessions#create', :path => 'api-auth'
    resources :sessions, :path => 'api-auth'
    resources :events, :path => 'events'
	end
end
