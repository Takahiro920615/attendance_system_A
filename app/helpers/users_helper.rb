module UsersHelper
  
  def format_basic_info(time)
    format("%.2f",((time.hour*60)+ time.min)/60.0)
  end
  
   def working_times(started_at, finished_at, change)
      if finished_at.present? && started_at.present?
        if change =="1" 
          format("%.2f",(((finished_at.hour - started_at.hour))/60.0/60.0)+24)
        else
          format("%.2f",((finished_at - started_at)/60.0)/60.0)
            
        end
      end
   end
end