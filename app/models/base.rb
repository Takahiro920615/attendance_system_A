class Base < ApplicationRecord
  
  validates :base_no, presence: true
  validates :base_name, presence: true
  validates :attendance_type, presence: true
end
