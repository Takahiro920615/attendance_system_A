class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note,length: { maximum: 50}

  validate :started_at_need_finished_at

  def started_at_need_finished_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end