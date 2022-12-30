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
   
   patch 'attendances/update_one_month_request'
   
   get 'worker'
  end 

  
  resources :attendances, only: :update do
    member do

  #勤怠承認
      get 'edit_attendance_change_approval'
      patch 'update_attendance_approval_change'

     #１ヶ月の勤怠承認
      get 'edit_one_month_status'
      patch 'update_one_month_status'
    end 
  end
end
  
 
 
 resources :bases, only:[:new, :index, :create, :edit, :update, :destroy]

end
  

