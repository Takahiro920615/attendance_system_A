module AttendancesHelper
    def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
    end 
    
    def working_times(finished_at, started_at, change)
      if finished_at.present? && started_at.present?
        if change == "1" 
          format("%.2f",(((finished_at.tomorrow - started_at))/3600.0))
        else
          format("%.2f",((finished_at - started_at)/60.0)/60.0)
            
        end
      end
    end
    
    #残業時間のフォーマット
    def overtime_culculation(change_end_time,designated_work_end_time,overtime_next_day )
      if overtime_next_day == "1"
        format("%.2f",((24-designated_work_end_time.hour) + change_end_time.hour)+ ((designated_work_end_time.min - change_end_time.min)/60.0)+24)
      else
        format("%.2f",((24-designated_work_end_time.hour) + change_end_time.hour) + ((designated_work_end_time.min - change_end_time.min )/60.0))
      end
    end
    
    # def overtime_hours( change,constant)
    # format("%.2f",((change_end_time.hour*60)- (designated_work_end_time.hour*60))/60.0)
    # end
        
end
