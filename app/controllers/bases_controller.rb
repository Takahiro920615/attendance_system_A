class BasesController < ApplicationController
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
     if @base.save
       flash[:success] = "拠点情報の作成に成功しました。"
       redirect_to bases_url
     end
  end
  
  def index
    @bases = Base.all
    
  end
  
  def edit
    @bases = Base.all
  end
  
  def update
    
  end
  
  def destroy
  end
  
  private
  
   def base_params
     params.require(:base).permit(:base_no, :base_name, :attendance_type )
   end
end
