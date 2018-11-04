Rails.application.routes.draw do
	root to: 'transactions#index'
  get '/offline', to: 'application#offline' 
  get '/ping', to: 'application#ping'

	authenticate :user do
		resources :statements, only: %i[new create]

		namespace :transactions do
			get '/',                             action: :index
      get '/routes',                       action: :routes
      get '/statement/:id',                action: :statement
			get '/:year/:month',                 action: :month
			get '/:year/:month/groupby/:group',  action: :groupby
      patch '/category/:id/:category',     action: :set_category
		end

    resources :goals, only: %i[index new edit create show update destroy]
	end
	
  devise_for :users
end
