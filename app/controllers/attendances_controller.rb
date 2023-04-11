class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :receive_change_attendance,:edit_attendance_change_approval,:attendance_log]
  before_action :set_user_ids, only: [:edit_attendance_change_approval,:update_attendance_change_approval,:edit_overtime_request,:update_overtime_request,:edit_overtime_approval,:update_overtime_approval, :edit_one_month_approval, :update_one_month_approval]
  before_action :logged_in_user,only: [:update, :edit_one_month]
  before_action :set_one_month, only: [:edit_one_month,:edit_overtime_request]
  before_action :select_superiors, only: [:edit_one_month, :update_change_attendance]
  before_action :set_attendance ,only: [:edit_overtime_request,:update_overtime_request]
  
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  INVALID_ERROR_MSG = "無効なデータがあったので、更新をキャンセルしました。"
  NO_CHECK_ERROR_MSG = "変更にチェックがないものは更新できません。"
  
  def new
    @attendances = attendance.new
  end
  
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
  
  #残業申請（edit)モーダル
  def edit_overtime_request
    @superiors = User.where(superior: true).where.not(id: @user.id)
  end
  
  #残業申請モーダルの更新
  def update_overtime_request
    if overtime_request_params[:change_end_time].blank? || overtime_request_params[:reason_for_application].blank? || overtime_request_params[:overtime_request_superior].blank?
      flash[:danger] = "終了予定時間、残業理由、または指示者確認印がありません"   
    else
      if overtime_request_params[:change_end_time].present? && overtime_request_params[:reason_for_application].present? && overtime_request_params[:overtime_request_superior].present?
        params[:attendance][:request_overtime_status] = "申請中"
        @attendance.update(overtime_request_params)
        flash[:success] = "残業申請しました"
      else
        flash[:danger] = "残業申請が正しくありません"
      end
    end
    redirect_to @user
  end
  
  def edit_overtime_approval
    @attendances = Attendance.where(overtime_request_superior: @user.name, request_overtime_status: "申請中").order(:worked_on).group_by(&:user_id)
  end
  
  def update_overtime_approval
    overtime_approval_params.each do |id,item|
      attendance = Attendance.find(id)
      if item[:overtime_check]=="1"
        if item[:request_overtime_status]=="なし"
          attendance.change_end_time = nil
          attendance.overtime_next_day = nil
          attendance.reason_for_application = nil
          attendance.overtime_request_superior = nil
        end
        attendance.update(item)
         flash[:success] = "残業申請を承認しました"
      else
         flash[:danger] = "残業申請の承認に失敗しました"
      end
    end
    redirect_to @user
  end
  
  
  def edit_one_month
    @superiors = User.where(superior: true).where.not(id: @user.id)
  end
  
#社員による勤怠情報の修正
   def update_one_month
     a_count = 0
     ActiveRecord::Base.transaction do
        attendances_params.each do |id, item|
         if item[:attendances_request_superiors].present?
           if item[:after_started_at].blank? && item[:after_finished_at].present?
             flash[:danger]="出勤時間が必要です"
             redirect_to attendances_edit_one_month_user_url(date:params[:date])
           return
           elsif item[:after_started_at].present? && item[:after_finished_at].blank?
             flash[:danger] = "退勤時間が必要です"
             redirect_to attendances_edit_one_month_user_url(date:params[:date])
           return
           
           end
           attendance = Attendance.find(id)
           attendance.attendance_approval_status = "申請中"
           a_count += 1
           attendance.update!(item)
          
          
         end
        end
         
        if a_count > 0
          flash[:success] = "勤怠編集を#{a_count}件、申請しました。"
          redirect_to user_url(date: params[:date])
          return
        else
          flash[:danger] = "上長を選択してください"
          redirect_to attendances_edit_one_month_user_url(date:params[:date])
          return
        end
     end
   rescue ActiveRecord::RecordInvalid
     flash[:danger] = "無効なデータがあったのため、更新をキャンセルします"
     redirect_to attendances_edit_one_month_user_url(date: params[:date])
     return
   end
   
   #勤怠変更申請(上長)のお知らせモーダルの表示
   def edit_attendance_change_approval
     @attendances = Attendance.where(attendances_request_superiors: @user.name, attendance_approval_status: "申請中").order(:worked_on).group_by(&:user_id)
   end
   
   #勤怠変更申請のお知らせモーダル更新
 


#  def receive_change_attendance
#   @change_attendance_requests = Attendance.order(:worked_on).where(edit_attendance_boss: @user.id, edit_attendance_request_status: "申請中")
#  end
 
 
#  def update_change_attendance
#   ActiveRecord::Base.transaction do
#      change_attendance_params.each do |id, item|
#       change_attendance = Attendance.find(id)
#       if params[:user][:attendance][id][:change] == "true"
#          if change_attendance.started_at.nil? || change_attendance.finished_at.nil?
#           change_attendance.started_at = change_attendance.after_started_at
#           change_attendance.finished_at = change_attendance.after_finished_at
#          end
#       else
#          flash[:danger] = NO_CHECK_ERROR_MSG
#       end
#      end
#   end
#   flash[:success] = "勤怠変更の決済を更新しました。"
#   redirect_to user_url(date params[:date])
#  rescue ActiveRecord::RecordInvalid
#   flash[:danger] = INVALID_ERROR_MSG
#   redirect_to user_url(date: params[:date])
#  end
 #勤怠変更申請
 def update_attendance_change_approval
   a_count = 0
   attendance_approval_params.each do |id, item|
     attendance = Attendance.find(id)
     if item[:attendance_approval_check] == "1"
       unless item[:attendance_approval_status] == "申請中"|| item[:attendance_approval_status] == "なし"
         if item[:attendance_approval_status] == "承認"
           if attendance.before_started_at.blank? && attendance.before_finished_at.blank?
             attendance.before_started_at = attendance.after_started_at
             attendance.before_finished_at = attendance.after_finished_at
             item[:started_at] =attendance.after_started_at
             item[:finished_at] =attendance.after_finished_at
           end
          item[:started_at] =attendance.after_started_at
          item[:finished_at] =attendance.after_finished_at
         end
        a_count += 1
        attendance.update(item)
       end
       attendance.update(after_started_at: nil, after_finished_at: nil, note: nil, attendances_approval_status: nil,attendance_approval_check:false, next_day: nil, change: nil) if item[:attendances_approval_status] == "なし"
     end 
   end       
   if a_count > 0
     flash[:success] = "勤怠変更の承認に成功しました"
   else
     flash[:danger] = "勤怠変更の承認に失敗しました"
   end
   redirect_to user_url(@user)
 end
   
   
 #１ヶ月の勤怠申請
 def update_one_month_request
     one_month_request_params.each do |id, item|
       attendance = Attendance.find(id)
       if item[:one_month_request_boss].present?
         item[:one_month_request_status] = "申請中"
         if attendance.update(item)
           flash[:success] = "#{attendance.one_month_request_boss}へ１ヶ月の勤怠申請しました"
         else
           flash[:danger] = "1ヶ月の勤怠変更に失敗しました。"
         end
       else
         flash[:danger] = "上長を選択してください"
       end
     end
     redirect_to user_url(date: params[:date])
 end
 
 def edit_one_month_approval
     @attendances = Attendance.where(one_month_request_boss: @user.name, one_month_request_status: "申請中").order(:worked_on).group_by(&:user_id)
 end
 
 
 def update_one_month_approval
     one_month_approval_params.each do |id, item|
       attendance = Attendance.find(id)
       if item[:one_month_approval_check] == "1"
         if item[:one_month_approval_status] == "なし"
           item[:one_month_approval_status] = nil
           item[:one_month_approval_check] = nil
         end
         attendance.one_month_request_status = nil
         attendance.update(item)
         flash[:success] = "所属長承認申請の結果を送信しました。"
       else
         flash[:danger] = "承認確認のチェックを入れてください。"
       end
     end
     redirect_to user_url(@user)
 end


 def attendance_log
   if params["select_year(1i)"].present? && params["select_month(2i)"].present?
      @first_day = (params["select_year(1i)"] + "-" + params["select_month(2i)"] + "-01").to_date
      @attendances = @user.attendances.where(worked_on: @first_day..@first_day.end_of_month,attendance_approval_status: "承認").order(:worked_on)
   end
 end
 
 def working_times(after_finished_at,after_started_at,change)
  if change == true
   format("%.2f",((after_finished_at.tomorrow - after_started_at)/3600.0))
  else
   format("%.2f",((after_finished_at - after_started_at)/60.0)/60.0)
  end
 end


 
 
  private
  
   def attendances_params
      params.require(:user).permit(attendances: [:note, :before_started_at, :before_finished_at, :after_started_at, :after_finished_at, :attendances_request_superiors])[:attendances]
   end 
   
   #残業申請内容のストロングパラメーター
   def overtime_request_params
     params.require(:attendance).permit([:change_end_time,:reason_for_application,:overtime_next_day,:overtime_request_superior,:request_overtime_status])
   end
   
   def overtime_approval_params
     params.require(:user).permit(attendances: [:request_overtime_status,:overtime_check])[:attendances]
   end

   # 勤怠情報修正承認・否認時のストロングパラメーター
   def change_attendance_params
     params.require(:user).permit(attendance: [:edit_attendance_request_status])[:attendances]
   end
   
   #勤怠変更承認のストロングパラメーター
   def attendance_approval_params
       params.require(:user).permit(attendances:[:before_started_at,:before_finished_at,:started_at,:finished_at,:after_started_at,:after_finished_at,:attendance_approval_status,:attendance_approval_check])[:attendances]
    
   end
   
   
   #１ヶ月の勤怠申請のストロングパラメーター
   def one_month_request_params
     params.require(:user).permit(attendances: [:one_month_request_boss, :one_month_request_status])[:attendances]
   end
   
   def one_month_approval_params
     params.require(:user).permit(attendances: [:one_month_approval_status, :one_month_approval_check])[:attendances]
   end
   
   def set_attendance
     @attendance = Attendance.find(params[:id])
   end
   
end
