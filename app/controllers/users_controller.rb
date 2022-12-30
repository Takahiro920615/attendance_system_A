class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update,:destroy,:edit_basic_info,:update_basic_info]
  before_action :logged_in_user, only: [:show,:edit,:update] #管理者のみに変更する(admin)
  before_action :correct_user, only: [:edit,:update] #管理者のみに変更する(admin)
  before_action :admin_user, only: [:destroy,:edit_basic_info,:update_basic_info]
  before_action :set_one_month, only: :show
  before_action :select_superiors, only: :show
  
   def show
   @worked_sum = @attendances.where.not(started_at:nil).count
   @one_month_request_status= Apply.where(one_month_boss: @user.id, one_month_request_status: "申請中")
  
   
   end
  
  
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
   @users = User.paginate(page: params[:page])
 end
 
 
 

  def edit
  end
  
  def update
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to @user
      else
        render :edit
      end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}を削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
     flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger]= "#{@user.name}の更新は失敗しました" + @user.errors.full_messages.join("、")
    end
    redirect_to users_url
  end
  
  def worker
   Attendance.where.not(started_at: nil).each do |attendance|
       if (Date.current == attendance.worked_on) && attendance.finished_at.nil?
           @worker_users = User.all.includes(:attendances)
       end
   end
  end
  
  


 private


    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:department,:designated_work_start_time, :designated_work_end_time)
    end
    
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    def workers_member
       @user.attendances.where(started_at:present, finished_at:blank)
    end
end