Rails.application.routes.draw do
  
  root to: 'products#search'

  resources :products, only:[:new, :create] do
    collection do
      get 'search'
    end
  end

end
