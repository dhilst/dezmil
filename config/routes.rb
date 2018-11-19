Rails.application.routes.draw do
	root to: 'transactions#index'
  get '/offline', to: 'application#offline' 
  get '/ping', to: 'application#ping'

	authenticate :user do
		resources :statements, only: %i[new create]
    resources :categories, only: :index

		namespace :transactions do
			get '/',                             action: :index
      get '/routes',                       action: :routes
      get '/statement/:id',                action: :statement
			get '/:year/:month',                 action: :month
			get '/:year/:month/groupby/:group',  action: :groupby
      patch '/category/:id/:category',     action: :set_category
      get 'by/category/:id/amount',        action: :category_amount
		end

    resources :goals, only: %i[index new edit create show update destroy]

    if Rails.env.development?
      scope :dev do
        get '/invite/preview', to: 'dev#invite_preview'
      end
    end
	end
	
  devise_for :users
end
