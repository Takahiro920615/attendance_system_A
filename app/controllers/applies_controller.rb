class AppliesController < ApplicationController
  before_action :select_superiors
  
  def receve_application_content
  @receve_application_content = Apply.order(:one_month).where(application_to_superior: @user.id, application_content: "申請中").group_by(&:user_id)
  end
end

private
 
 
 
 
  
 
