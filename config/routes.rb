Rails.application.routes.draw do
  get 'help/index'
	root to: 'transactions#index'
  get '/offline', to: 'application#offline' 
  get '/ping', to: 'application#ping'

	authenticate :user do
		resources :statements, only: %i[new create]
    resources :categories

		namespace :transactions do
			get '/',                             action: :index
      get '/statement/:id',                action: :statement
      patch '/category/:id/:category',     action: :set_category
      get 'by/category/:id/amount',        action: :category_amount

      scope '/:year/:month' do
        get '/',                action: :month
        get '/charts',          action: :charts
        get '/groupby/:group',  action: :groupby
      end
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
