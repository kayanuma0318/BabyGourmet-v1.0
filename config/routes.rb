Rails.application.routes.draw do
  # 認証に必要なルーティングを自動生成する
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions'
  }, skip: [:registrations, :sessions]
  # skip: [:registrations, :sessions]で自動生成するルーティングを制限する

  devise_scope :user do
    # devise_scope: どのルーティングを変更するかを指定する
    get 'sign_up', to: 'users/registrations#new', as: :new_user
    post 'users', to: 'users/registrations#create', as: :users
    get 'users/:id/edit', to: 'users/registrations#edit', as: :edit_user
    patch 'users/:id', to: 'users/registrations#update', as: :user

    get 'login', to: 'users/sessions#new', as: :login
    post 'login', to: 'users/sessions#create'
    delete 'logout', to: 'users/sessions#destroy', as: :logout
  end

  root 'tops#index'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
