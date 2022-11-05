Rails.application.routes.draw do
  get '/signup', to:'users#new'

  root 'attendance_page#top'

 resources :users
end
