Rails.application.routes.draw do
  resources :testimonials
  devise_for :users

  get '/secret', to: 'pages#secret', as: :secret
  root to: 'pages#index'

  get '/dashboard', to: 'testimonials#dashboard', as: :dashboard

  get '/latest', to: 'testimonials#latest', as: :latest

  get '/feeding', to: 'pages#feeding', as: :feeding

  get '/shelter', to: 'pages#shelter', as: :shelter

  get '/icnatestimonials', to: 'pages#icnatestimonials', as: :icnatestimonials

  get '/donate', to: 'pages#donate', as: :donate

  get '/contact', to: 'pages#contact', as: :contact

  get '/donateblog', to: 'pages#donateblog', as: :donateblog

  get '/testimonialsblog', to: 'pages#testimonialsblog', as: :testimonialsblog

  get '/shelterblog', to: 'pages#shelterblog', as: :shelterblog

  get '/feedinghomelessblog', to: 'pages#feedinghomelessblog', as: :feedinghomelessblog

  get '/news', to: 'pages#news', as: :news

end
