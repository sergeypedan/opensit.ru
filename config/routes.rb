Opensit::Application.routes.draw do

  root to: 'pages#front'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  get 'me' => 'users#me'

  constraints(:username => /[^\/]+/) do
    get '/u/:username',           to: 'users#show',      as: :user
    get '/u/:username/following', to: 'users#following', as: :following_user
    get '/u/:username/followers', to: 'users#followers', as: :followers_user
    get '/u/:username/export',    to: 'users#export'
    get '/u/:username/feed',      to: 'users#feed',      as: :feed, defaults: { format: 'atom' }
    delete '/u/:username',        to: 'users#destroy',   as: :delete_user
  end

  get 'about',      to: 'pages#about'
  get 'calendar',   to: 'pages#calendar', as: :calendar
  get 'contribute', to: 'pages#contribute'
  get 'contact',    to: 'pages#contact'

  get 'explore',                   to: 'pages#explore'
  get 'explore/tags',              to: 'pages#tag_cloud',    as: :explore_tags
  get 'explore/comments',          to: 'pages#new_comments', as: :explore_comments
  get 'explore/users/online',      to: 'pages#online_users', as: :explore_online_users
  get 'explore/users/new',         to: 'pages#new_users',    as: :explore_new_users
  get 'explore/users/active',      to: 'pages#active_users', as: :explore_active_users
  get 'explore/users/new/sitters', to: 'pages#new_sitters',  as: :explore_new_sitters

  get '/global-feed',   to: 'users#feed', defaults: { format: 'atom', scope: 'global' }
  get '/favs',          to: 'favourites#index', as: :favs
  get '/messages/sent', to: 'messages#sent', as: :sent_messages
  get '/notifications', to: 'notifications#index'
  get '/welcome',       to: 'users#welcome'
  get '/search',        to: 'search#main'
  get '/tags/:id',      to: 'tags#show', as: :tag

  resources :sits do
    resources :comments
  end

  resources :favourites, only: [:create, :destroy]
  resources :goals
  resources :likes, only: [:create, :destroy]
  resources :messages, except: [:edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :reports, only: [:create]

  # Crawl live site, but not staging
  get 'robots.txt', to: 'pages#robots'

  get '/split' => Split::Dashboard, anchor: false, constraints: lambda { |request|
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    request.env['warden'].user.email == 'danbartlett@gmail.com'
  }
end
