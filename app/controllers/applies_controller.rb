class AppliesController < ApplicationController
  before_action :set_one_month
  before_action :select_superiors
  
  INVALID_ERROR_MESSAGE = "無効な入力があったっ為、更新をキャンセルしました。"

 def request_one_month
   ActiveRecord::Base.transaction do
     one_month_request_params.each do |id, item|
       if params[:user][:applies][id][:application_to_superior].blank?
         flash[:danger]="上長を選択してください"
         redirect_to user_url(date: params[:date]) and return
       else
         one_month_request = Apply.find(id)
         one_month_request.update_attributes!(item)
         @superior = User.find(params[:user][:applies][id][:application_to_superior])
       end
     end
   end
   flash[:success] = "#{@superior.name}に１ヶ月分の勤怠申請をしました。"
   redirect_to user_url(date: params[:date])
 rescue ActiveRecord::RecordInvalid
   flash[:danger] =　INVALID_ERROR_MESSAGE
   redirect_to user_url(date: params[:date])
 end

  
  def receve_application_content
  @receve_application_content = Apply.order(:one_month).where(application_to_superior: @user.id, application_content: "申請中").group_by(&:user_id)
  end

  def apply_application_content
  end


end

private

  def one_month_request_params
    params.require(:user).permit(applies: [:one_month, :one_month_boss, :one_month_request_status, :id ])[:applies]
  end
  
  
 
 
 

  
 
