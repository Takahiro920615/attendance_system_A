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
end