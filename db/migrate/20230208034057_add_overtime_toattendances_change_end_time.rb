class AddOvertimeToattendancesChangeEndTime < ActiveRecord::Migration[5.1]
  def change
    # add_column :attendances, :spread_day, :boolean, default: false
    add_column :attendances, :change_end_time, :datetime
    add_column :attendances, :overtime_next_day, :boolean, default: false
    add_column :attendances, :reason_for_application, :string
    add_column :attendances, :overtime_request_superior, :string
    add_column :attendances, :request_overtime_status, :string
    add_column :attendances, :overtime_check, :boolean, default: false
   
  end
end


