class AddAttendanceRequestsBossToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_attendance_boss, :integer
  end
end
