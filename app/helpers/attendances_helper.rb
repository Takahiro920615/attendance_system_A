module AttendancesHelper
  require 'attendances_helper'
    def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
    end 
    
    def working_times(after_finished_at,after_started_at,change)
      start_time = Time.parse(after_started_at)
      end_time = Time.parse(after_finished_at)
      
        if change == "1" 
          if end_time <= start_time
            format("%.2f",(((24+ end_time.hour) - start_time.hour) + (end_time.min - start_time.min)/60.0))
          else
            format("%.2f",((end_time - start_time)/3600.0))
          end
        else change == "0"
          format("%.2f",((end_time - start_time)/60.0)/60.0)
        end
  
    
       if start_time.hour == end_time.hour && start_time.min == end_time.min && change =="1"
         working_hours = 24.0
       end
       format("%.2f", working_hours)
    end
    
   
    
    #残業時間のフォーマット
    def overtime_culculation(change_end_time,designated_work_end_time,overtime_next_day )
      if overtime_next_day == "1"
        format("%.2f",((24-designated_work_end_time.hour) + change_end_time.hour)+ ((designated_work_end_time.min - change_end_time.min)/60.0)+24)
      else overtime_next_day =="0"
        format("%.2f",((designated_work_end_time.hour) - change_end_time.hour) + ((designated_work_end_time.min - change_end_time.min )/60.0))
      end
    end
    
    # def overtime_hours( change,constant)
    # format("%.2f",((change_end_time.hour*60)- (designated_work_end_time.hour*60))/60.0)
    # end
        
end
