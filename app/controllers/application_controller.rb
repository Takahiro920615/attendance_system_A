class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
    def set_user
      @user = User.find(params[:id])
    end
    
    def set_user_id
      @user_id = User.find_by(id: params[:user_id])
    end
    
    def set_user_ids
     @user = User.find(params[:user_id])
    end    
  
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to (root_url) unless @user == current_user
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
   def select_superiors
   @superiors = User.all.where(superior: true).where.not(id: @user)
   end
   
  def admin_ban
    if current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to root_url
    end
  end
   


  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
  
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    # @one_month_attendances = @user.applies.where(one_month: @first_day, one_month_request_status: "")
  
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
 
 
end
