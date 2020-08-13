Rails.application.routes.draw do
	namespace 'api' do		
		resources :users, only: [:create], :path => 'create-user'
		resources :auth, only: [:create], :path => 'api-auth'
		resources :events, :path => 'events'
	end
end