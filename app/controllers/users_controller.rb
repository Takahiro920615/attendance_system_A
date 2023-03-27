class UsersController < ApplicationController
  before_action :set_user, only:[:show,:edit,:update,:destroy,:edit_basic_info,:update_basic_info,:show_confirmation,:form_edit,:info_correction_user_path]
  before_action :logged_in_user, only: [:index,:edit,:update,:destroy,:edit_basic_info,:update_basic_info] #管理者のみに変更する(admin)
  before_action :correct_user, only: [:show,:edit,:update] 
  before_action :admin_user, only: [:index,:worker,:destroy,:edit_basic_info,:update_basic_info,:form_edit,:info_correction]
  before_action :set_one_month, only: [:show, :show_confirmation]
  before_action :select_superiors, only: [:show]
  
   def show
   @worked_sum = @attendances.where.not(started_at:nil).count
   @superiors = User.where(superior: true).where.not(id: @user.id)
   @one_month_approval_sum = Attendance.where(one_month_request_boss: @user.name, one_month_request_status: "申請中").count
   @attendances_sum = Attendance.where(attendances_request_superiors: @user.name, attendance_approval_status: "申請中").count
   @attendance_overtime_sum = Attendance.where(overtime_request_superior: @user.name, request_overtime_status: "申請中").count
    respond_to do |format|
        format.html
        format.csv do |csv|
          send_attendances_csv(@attendances)
      end
    end   
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
   @users = User.paginate(page: params[:page]).order(:id)
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
  
  def show_confirmation
   @worked_sum = @attendances.where.not(started_at:nil).count
   @superiors = User.where(superior: true).where.not(id: @user.id)
   @one_month_approval_sum = Attendance.where(one_month_request_boss: @user.name, one_month_request_status: "申請中").count
  end
  
  def import
    if params[:file].blank?
        flash[:danger] = "csvファイルが選択されていません"
        redirect_to users_url
    else
      if User.import(params[:file])
          flash[:success] = "CSVファイルのインポートに成功しました"
      else
          flash[:danger] = "CSVファイルのインポートに失敗しました"
      end
      redirect_to users_url
    end
  end
  
  def form_edit
  end
  
  def info_correction
  end

 private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:department,:designated_work_start_time, :designated_work_end_time)
    end

    
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :department, :employee_number, 
                                   :uid, :designated_work_start_time, :designated_work_end_time,
                                   :password, :password_confirmation)
    end
    
    def workers_member
       @user.attendances.where(started_at:present, finished_at:blank)
    end
    
    def send_attendances_csv(attendances)
        bom = "\uFEFF"
        
        csv_data = CSV.generate do |csv|
          header = %w(日付 出勤時間 退勤時間)
          csv << header
          
          attendances. each do |day|
              column_values = [
                  day.worked_on.strftime("%Y年%m月%d日(#{$days_of_the_week[day.worked_on.wday]})"),
                  if day.started_at.present? 
                      l(day.started_at, format: :time)
                  else
                      nil
                  end,
                  if day.finished_at.present? 
                      l(day.finished_at, format: :time)
                  else
                      nil
                  end
              ]
              csv << column_values
          end
        end
        send_data(csv_data, filename: "勤怠一覧.csv")
    end
  
  
end