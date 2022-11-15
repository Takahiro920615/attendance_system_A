Rails.application.routes.draw do
  get '/signup', to:'users#new'

  root 'attendance_page#top'
  
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete 'logout', to:'sessions#destroy'

 resources :users do
   member do
   get 'edit_basic_info'
   patch 'update_basic_info'
   end
 resources :attendances, only: :update
 
 end
end
