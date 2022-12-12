class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user,only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :select_superiors, only: [:edit_one_month, :update_change_attendance]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  INVALID_ERROR_MSG = "無効なデータがあったので、更新をキャンセルしました。"
  NO_CHECK_ERROR_MSG = "変更にチェックがないものは更新できません。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec:0))
        
        flash[:info] = "おはようございます"
      else
        flash[:danger] =  UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec:0))
        flash[:info] = "お疲れ様でした。"
      else
        flas[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
#社員による勤怠情報の修正
 def update_one_month
   ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if (item)[:after_started_at].present? && (item)[:after_finished_at].present?
          if (item)[:edit_attendance_boss].present? && (item)[:note].present?
            attendance.edit_attendance_request_status = "申請中" 
            attendance.update_attributes!(item)
          else 
            flash[:danger] = "申請箇所には出社、退社、備考、指示者確認㊞が必要です。"
          end
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新・申請しました。"
    redirect_to user_url(date: params[:date])
 rescue ActiveRecord::RecordInvalid
    flash[:danger] = INVALID_ERROR_MSG
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
 end
 
 def receive_change_attendance
   @change_attendance_requests = Attendance.order(:worked_on).where(edit_attendance_boss: @user.id, edit_attendance_request_status: "申請中")
 end
 
 
 def update_change_attendance
   ActiveRecord::Base.transaction do
     change_attendance_params.each do |id, item|
       change_attendance = Attendance.find(id)
       if params[:user][:attendance][id][:change] == "true"
         if change_attendance.started_at.nil? || change_attendance.finished_at.nil?
           change_attendance.started_at = change_attendance.after_started_at
           change_attendance.finished_at = change_attendance.after_finished_at
         end
       else
         flash[:danger] = NO_CHECK_ERROR_MSG
       end
     end
   end
   flash[:success] = "勤怠変更の決済を更新しました。"
   redirect_to user_url(date params[:date])
 rescue ActiveRecord::RecordInvalid
   flash[:danger] = INVALID_ERROR_MSG
  redirect_to user_url(date: params[:date])
 end
   
 
 
 
 
  private
  
   def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :before_started_at, :before_finished_at, :after_started_at, :after_finished_at, :edit_attendance_boss, :note])[:attendances]
   end 

   # 勤怠情報修正承認・否認時のストロングパラメーター
   def change_attendance_params
     params.require(:user).permit(attendance: [:edit_attendance_request_status])[:attendances]
   end
end
