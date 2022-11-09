class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
 def create
   @user = User.new(user_params)
   if @user.save
     log_in @user
     flash[:success] = "新規作成に成功しました。"
     redirect_to @user
      
   else
     flash.now[:danger] = "ユーザー登録に失敗しました"
     render :new
   end
 end
 
 def index
 end
 
 
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to @user
      else
        render :edit
      end
  end




private


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end