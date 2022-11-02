Rails.application.routes.draw do
  get 'users/new'

  root 'attendance_page#top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
