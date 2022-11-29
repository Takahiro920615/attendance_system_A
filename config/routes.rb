Rails.application.routes.draw do
  root 'attendance_page#top'
  
  get '/signup', to:'users#new'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete 'logout', to:'sessions#destroy'

 
 resources :users do
   member do
   get 'edit_basic_info'
   patch 'update_basic_info'
   get 'attendances/edit_one_month'
   patch 'attendances/update_one_month'
   get 'worker'
   end
 resources :attendances, only: :update do
 end
 end
 
 resources :bases, only:[:new, :index, :create, :edit, :update, :destroy]

  

end
