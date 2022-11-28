class Base < ApplicationRecord
  
  validates :base_no, presence: true, allow_nil: true
  validates :base_name, presence: true, allow_nil: true
  validates :attendance_type, presence: true, allow_nil: true
end
