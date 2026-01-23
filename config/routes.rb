Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'towers/create', to: 'towers#create'
      post 'towers/play', to: 'towers#play'
      post 'towers/cashout', to: 'towers#cashout'
    end
  end
end
