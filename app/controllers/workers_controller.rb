class WorkersController < ApplicationController
  
  def show
    @user = User.all
      
  end
end
