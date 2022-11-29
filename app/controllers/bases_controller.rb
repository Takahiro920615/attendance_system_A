class BasesController < ApplicationController
 
  
  def new
   @base = Base.new
  end
  
  def create
    @base = Base.create(base_params)
     if @base.save
       flash[:success] = "拠点情報の作成に成功しました。"
       redirect_to bases_url
     else
       render :new
     end
  end
  
  def index
    @bases = Base.all.order(id: "DESC")
  end
   
  def show
 
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
   @base = Base.find_by(params[:id])
    @base.destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_url
  end
 
  
  private
  
   def base_params
     params.require(:base).permit(:base_no, :base_name, :attendance_type )
   end

end
