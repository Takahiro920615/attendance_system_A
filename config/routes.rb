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
   
   #勤怠を確認する
   get 'show_confirmation'
  
   #１ヶ月の勤怠申請
   patch 'attendances/update_one_month_request'
   
   #勤怠承認
   get 'attendances/edit_attendance_change_approval'
   patch 'attendances/update_attendance_approval_change'
   
   get 'worker'
  end 

  
  resources :attendances, only: :update do
    member do
      #1ヶ月の勤怠承認
      get 'edit_one_month_approval'
      patch 'update_one_month_approval'
    end 
  end
end
  
 
 
 resources :bases, only:[:new, :index, :create, :edit, :update, :destroy]

end
  

