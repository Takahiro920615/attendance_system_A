module ApplicationHelper
  
  #カスタムヘルパー　page_name ="" で指定文字をビューに入力することで反映できるようになる。
  def full_title(page_name ="")
    base_title = "AttendanceApp"
    if page_name.empty?
      base_title
    else
      page_name + "|" + base_title
    end
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
