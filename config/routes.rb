Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :home, only: %i(index) do
    get 'dashboard', on: :collection
  end

  resources :notes, only: %i(index new create edit update show destroy) do
    get 'shared_notes', on: :collection
    get 'tag_notes', on: :collection
  end

  resources :users, only: %i(index) do
    post 'shared_to', on: :collection
    get 'remove', on: :collection
  end
end
