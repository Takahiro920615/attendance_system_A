class Attendance < ApplicationRecord
  belongs_to :user
  
  
  validates :worked_on, presence: true
  validates :note,length: { maximum: 50}

  validate :started_at_need_finished_at
  validate :started_at_fast_than_finished_at

  def started_at_need_finished_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_fast_than_finished_at
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  def working_times(after_finished_at,after_started_at,change)
   if change == true
    format("%.2f",((after_finished_at.tomorrow - after_started_at)/3600.0))
   else
    format("%.2f",((after_finished_at - after_started_at)/60.0)/60.0)
   end
  end
 
end