Rails.application.routes.draw do
  root 'attendance_page#top'
  
  get '/signup', to:'users#new'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete 'logout', to:'sessions#destroy'
  
  
  resources :bases, only:[:new, :index, :create, :edit, :update, :destroy]

 
 resources :users do
  member do
   get 'edit_basic_info'
   patch 'update_basic_info'
   get 'form_edit'
   get 'info_correction'
   get 'attendances/edit_one_month'
   patch 'attendances/update_one_month'
   #勤怠を確認する
   get 'show_confirmation'
   #１ヶ月の勤怠申請
   patch 'attendances/update_one_month_request'
   get 'worker'
   
  end 
  collection {post :import}
  
  resources :attendances, only: :update do
    member do
      
      #残業申請
      get 'edit_overtime_request'
      patch 'update_overtime_request'
      
      #残業申請承認
      get 'edit_overtime_approval'
      patch 'update_overtime_approval'
      
      #勤怠承認
      get 'edit_attendance_change_approval'
      patch 'update_attendance_change_approval'  
      
      #1ヶ月の勤怠承認
      get 'edit_one_month_approval'
      patch 'update_one_month_approval'
      
      get 'attendance_log'
    end 
  end
 end
end
  

