Rails.application.routes.draw do
	root to: 'transactions#index'

	authenticate :user do
		resources :statements, only: %i[new create]

		namespace :transactions do
			get '/', action: :index
			get '/:year/:month',  action: :index
			get '/:year/:month/fuzzy/', action: :search
		end
	end
	
  devise_for :users
end
