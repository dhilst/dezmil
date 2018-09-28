Rails.application.routes.draw do
	root to: 'transactions#index'

	authenticate :user do
		resources :statements
		resources :transactions
	end
	
  devise_for :users
end
