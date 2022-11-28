class BasesController < ApplicationController
 
  
  def new
   @base = Base.new
  end
  
   def index
    @bases = Base.all
   
   end
   
   def show
    @bases = Bases.all
    @base = Base.find(params[:id])
   end
  
 
  def create
    @base = Base.new(base_params)
     if @base.save
       flash[:success] = "拠点情報の作成に成功しました。"
       redirect_to bases_url
     else
       render :new
     end
  end

  def edit
   @base = Base.find(params[:id])
  end
  
  def update
   @base = Base.find(params[:id])
     if @base.update_attributes(base_params)
       flash[:succsss] = "拠点情報を更新しました。"
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
   
   
end
