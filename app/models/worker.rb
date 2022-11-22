class Worker < ApplicationRecord
  has_many :user
  has_many :attendance
  
  validate :worker
  
end
