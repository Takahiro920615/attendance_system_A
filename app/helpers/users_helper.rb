module UsersHelper
  
  def format_basic_info(time)
    format("%.2f",((time.hour*60)+ time.min)/60.0)
  end
  
  def format_overtime_info(finished_at, designated_work_end_time)
    overtime_minutes = (finished_at - designated_work_end_time).to_i
    format("%.2f", overtime_minutes / 60.0/60.0)
  end
end