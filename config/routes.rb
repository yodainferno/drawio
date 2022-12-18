Rails.application.routes.draw do
  get 'paint', to: 'canvas#paint'
  get 'my', to: 'canvas#my'
  get 'gallery', to: 'canvas#gallery'

  post 'save_paint', to: 'canvas#save_paint'

  devise_for :users

  root :to => "canvas#paint"
end