Rails.application.routes.draw do

  root 'tops#index'

  # 認証に必要なルーティングを自動生成する
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions'
  }, skip: %i[registrations, sessions]
  # skip: [:registrations, :sessions]で自動生成するルーティングを制限する
  # 制限理由: ユーザー登録、ログイン、ログアウトのルーティングを可読性良くカスタマイズするため

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

  resources :recipes do
    collection do
      get 'add_ingredient_fields'
      get 'add_step_fields'
      delete 'remove_ingredient_fields'
      delete 'remove_step_fields'
      post 'reset_ingredient_fields'
      post 'reset_step_fields'
      post 'preview_image', to: 'recipes#preview_image'
    end
    member do
      delete 'remove_image'
    end
    resources :comments, only: %i[create edit update destroy], shallow: true
      # shallow: trueでネストを浅くする(削除時、comment_idのみで削除可能)
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
