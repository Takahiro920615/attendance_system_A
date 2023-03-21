class BasesController < ApplicationController
 before_action :admin_user, only: [:index]
 before_action :set_base, only: [:index,:edit]
 
  def index
    @bases = Base.all.order(id: "DESC")
    @base = Base.new
  end 
  
  def create
    @base = Base.new(base_params)
     if @base.save
       flash[:success] = "拠点情報を追加しました"
       redirect_to bases_url
     else
      flash[:danger] = "拠点情報を追加できません"
      @bases = Base.all
      render :index
     end
  end
  
  
   
  def show
  end
  
  def edit
  end
  
  def update
   @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
    flash[:success] = "拠点情報を更新しました"
    redirect_to bases_url
    else
     render :edit
    end
  end
    
  def destroy
   @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_url
  end
 
  private
  
   def base_params
     params.require(:base).permit(:base_no, :base_name, :attendance_type )
   end
   
   def set_base
      @base = Base.find_by(params[:id])
   end
    
end
